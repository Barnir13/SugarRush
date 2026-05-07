extends CharacterBody2D

var SPEED_MILK = 40.0
var direction = -1.0
var dead = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var head_hitbox: Area2D = $HeadHitbox
@onready var side_hitbox: Area2D = $SideHitbox
@onready var timer: Timer = $Timer


func _ready():
	side_hitbox.body_entered.connect(_on_side_hitbox_body_entered)
	head_hitbox.body_entered.connect(_on_head_hitbox_body_entered)

	if timer and not timer.autostart:
		timer.start()


func _physics_process(delta):
	if dead:
		return

	position.x += direction * SPEED_MILK * delta


func _on_timer_timeout():
	if dead:
		return

	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


# =========================
# PLAYER HIT (SIDE)
# =========================
func _on_side_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):

		if not ("invincible" in body and body.invincible):
			GameManager.respawn_player()


# =========================
# HEAD STOMP (KILL ENEMY)
# =========================
func _on_head_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		die(body)


# =========================
# DEATH FUNCTION
# =========================
func die(player):
	dead = true

	# ❗ MINDEN HITBOX OFF
	head_hitbox.set_deferred("monitoring", false)
	side_hitbox.set_deferred("monitoring", false)

	var head_col = head_hitbox.get_node_or_null("CollisionShape2D")
	var side_col = side_hitbox.get_node_or_null("CollisionShape2D")

	if head_col:
		head_col.set_deferred("disabled", true)
	if side_col:
		side_col.set_deferred("disabled", true)

	# ❗ TELJES PHYSICS KIKAPCSOLÁS (ghost mód)
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)

	# Player bounce
	if "velocity" in player:
		player.velocity.y = -250

	# Death anim
	animated_sprite_2d.play("death")

	await animated_sprite_2d.animation_finished

	queue_free()
