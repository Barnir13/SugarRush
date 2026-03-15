extends CharacterBody2D

var SPEED_MILK = 40.0
var direction = -1.0
var dead = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var head_hitbox: Area2D = $HeadHitbox
@onready var side_hitbox: Area2D = $SideHitbox
@onready var timer: Timer = $Timer # Feltételezve, hogy van alatta egy Timer node

func _ready():
	# Signalok bekötése (így biztosan működni fognak)
	side_hitbox.body_entered.connect(_on_side_hitbox_body_entered)
	head_hitbox.body_entered.connect(_on_head_hitbox_body_entered)
	
	# Ha a Timer nincs bekötve az editorban, itt is megteheted:
	if timer:
		timer.timeout.connect(_on_timer_timeout)
		if timer.autostart == false:
			timer.start()

func _physics_process(delta):
	if dead:
		return

	# Mozgás (position-alapú, ahogy a gofrinál kérted)
	position.x += direction * SPEED_MILK * delta

func _on_timer_timeout():
	if dead:
		return

	# Irányváltás és tükrözés
	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h

# Oldalról ütközés (Player halál)
func _on_side_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		# Megnézzük, a player épp sebezhetetlen-e
		if not ("invincible" in body and body.invincible):
			get_tree().call_deferred("reload_current_scene")

# Felülről ugrás (Enemy halál)
func _on_head_hitbox_body_entered(body: Node) -> void:
	if dead:
		return

	if body.is_in_group("Player"):
		die(body)

func die(player):
	dead = true
	
	# Kikapcsoljuk az ütközéseket, hogy ne sebezzen halál közben
	head_hitbox.set_deferred("monitoring", false)
	side_hitbox.set_deferred("monitoring", false) # Fontos: az oldalát is kapcsold ki!
	
	# Player visszapattan
	if "velocity" in player:
		player.velocity.y = -250

	# Lejátsszuk a tejes kifolyós/összecsuklós halál animációt
	animated_sprite_2d.play("death")
	
	# Megvárjuk, amíg vége az animációnak
	await animated_sprite_2d.animation_finished

	# Törlés a memóriából
	queue_free()
