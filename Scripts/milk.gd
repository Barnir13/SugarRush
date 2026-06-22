extends CharacterBody2D

var SPEED_MILK = 40.0
var direction = -1.0
var dead = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var head_hitbox: Area2D = $HeadHitbox
@onready var side_hitbox: Area2D = $SideHitbox
@onready var timer: Timer = $Timer
@onready var sfx_milk_death: AudioStreamPlayer2D = $sfx_milk_death


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

func _on_side_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		# Ha a játékos nem sebezhetetlen
		if not ("invincible" in body and body.invincible):
			# Ha a játékos még nem haldoklik éppen
			if "is_dying" in body and not body.is_dying:
				# Megnézzük, hogy megvan-e a feldobós halál függvénye
				if body.has_method("die_from_enemy"):
					body.die_from_enemy() # <-- ITT INDÍTJUK EL A FELDOBÓS ANIMÁCIÓT!
				else:
					# Biztonsági mentés: ha nincs ilyen függvény, csak simán respawnol
					body.is_dying = true
					GameManager.respawn_player()

func _on_head_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		die(body)

func die(player):
	dead = true
	GameManager.add_score(500)
	sfx_milk_death.play()
	
	head_hitbox.set_deferred("monitoring", false)
	side_hitbox.set_deferred("monitoring", false)

	var head_col = head_hitbox.get_node_or_null("CollisionShape2D")
	var side_col = side_hitbox.get_node_or_null("CollisionShape2D")

	if head_col:
		head_col.set_deferred("disabled", true)
	if side_col:
		side_col.set_deferred("disabled", true)

	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)

	if "velocity" in player:
		player.velocity.y = -250

	animated_sprite_2d.play("death")

	await animated_sprite_2d.animation_finished

	queue_free()
