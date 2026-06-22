extends CharacterBody2D

var SPEED1 = 40.0
var direction = 1.0
var dead = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var head_hitbox: Area2D = $HeadHitbox
@onready var side_hitbox: Area2D = $SideHitbox
@onready var sfx_waffle_death: AudioStreamPlayer2D = $sfx_waffle_death


func _ready():
	side_hitbox.body_entered.connect(_on_side_hitbox_body_entered)
	head_hitbox.body_entered.connect(_on_head_hitbox_body_entered)


func _physics_process(delta):
	if dead:
		return

	position.x += direction * SPEED1 * delta


func _on_timer_timeout():
	if dead:
		return

	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_side_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		if not ("invincible" in body and body.invincible):
			if body.has_method("die_from_enemy"):
				body.die_from_enemy()
			else:
				GameManager.respawn_player()


func _on_head_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		dead = true
		GameManager.add_score(500)
		sfx_waffle_death.play()

		side_hitbox.set_deferred("monitoring", false)
		head_hitbox.set_deferred("monitoring", false)

		var side_col = side_hitbox.get_node_or_null("CollisionShape2D")
		var head_col = head_hitbox.get_node_or_null("CollisionShape2D")

		if side_col:
			side_col.set_deferred("disabled", true)
		if head_col:
			head_col.set_deferred("disabled", true)

		if "velocity" in body:
			body.velocity.y = -250

		animated_sprite_2d.play("death")

		set_collision_layer_value(2, false)
		set_collision_mask_value(1, false)

		await animated_sprite_2d.animation_finished

		queue_free()
