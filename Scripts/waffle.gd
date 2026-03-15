extends CharacterBody2D

var SPEED1 = 40.0
var direction = 1.0
var dead = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var head_hitbox: Area2D = $HeadHitbox
@onready var side_hitbox: Area2D = $SideHitbox


func _ready():
	side_hitbox.body_entered.connect(_on_side_hitbox_body_entered)
	
	# HeadHitbox jelezze felülről
	head_hitbox.body_entered.connect(_on_head_hitbox_body_entered)


func _physics_process(delta):
	if dead:
		return

	# egyszerű patrol: pozíció frissítése delta-val
	position.x += direction * SPEED1 * delta

	# irányváltás falnál / triggernél (példa)
	# ha van timer vagy collision, akkor direction *= -1


func _on_timer_timeout():
	if dead:
		return

	# Irányváltás
	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


# Oldalról ütközés
func _on_side_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		# Fánk effekt figyelése
		if not ("invincible" in body and body.invincible):
			get_tree().call_deferred("reload_current_scene")  # Player halál


# Felülről ugrás
func _on_head_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		dead = true

		# Head hitbox kikapcsolása deferred módon
		head_hitbox.set_deferred("monitoring", false)
		head_hitbox.get_node("CollisionShape2D").set_deferred("disabled", true)

		# Player visszapattanása
		if "velocity" in body:
			body.velocity.y = -250

		# Death animáció
		animated_sprite_2d.play("death")
		await animated_sprite_2d.animation_finished

		# Enemy eltűnik
		queue_free()
