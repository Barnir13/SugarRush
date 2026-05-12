extends CharacterBody2D

class_name Player

@export var speed = 10
@export var jump_power = 10

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0

# --- Jump system ---
var max_jumps := 1
var jumps_left := 1
var _powerup_id := 0

# --- Invincibility ---
var invincible := false
var _inv_id := 0

# --- Speed boost ---
var speed_boost := 1.0
var _speed_id := 0

# --- POWERUP TIMERS (SEPARATE) ---
var inv_time_left := 0.0
var inv_max_time := 0.0

var speed_time_left := 0.0
var speed_max_time := 0.0

var jump_time_left := 0.0
var jump_max_time := 0.0

@onready var spr: Sprite2D = get_node_or_null("Node2D/Sprite2D")
@onready var cam: Camera2D = get_node_or_null("Camera2D")
@onready var sfx_powerup: AudioStreamPlayer2D = $sfx_powerup
@onready var sfx_jump: AudioStreamPlayer2D = $sfx_jump


func _ready() -> void:
	add_to_group("Player")
	jumps_left = max_jumps

	if GameManager.has_checkpoint:
		global_position = GameManager.checkpoint_position

	GameManager.set_player(self)

	if cam:
		cam.reset_smoothing()


func reset_powerups():

	max_jumps = 1
	jumps_left = 1

	invincible = false
	set_collision_mask_value(2, true)

	speed_boost = 1.0

	inv_time_left = 0.0
	speed_time_left = 0.0
	jump_time_left = 0.0

	if spr:
		spr.modulate.a = 1.0


# -------------------------
# DOUBLE JUMP
# -------------------------
func enable_double_jump(duration: float) -> void:

	sfx_powerup.play()

	_powerup_id += 1
	var my_id := _powerup_id

	max_jumps = 2
	jumps_left = min(jumps_left, max_jumps)

	jump_time_left = duration
	jump_max_time = duration

	await get_tree().create_timer(duration).timeout

	if my_id != _powerup_id:
		return

	max_jumps = 1
	jumps_left = min(jumps_left, max_jumps)

	jump_time_left = 0.0


# -------------------------
# INVINCIBILITY (DONUT)
# -------------------------
func enable_invincibility(duration: float) -> void:

	sfx_powerup.play()

	_inv_id += 1
	var my_id := _inv_id

	invincible = true
	set_collision_mask_value(2, false)

	inv_time_left = duration
	inv_max_time = duration

	if spr:
		spr.modulate.a = 0.6

	await get_tree().create_timer(duration).timeout

	if my_id != _inv_id:
		return

	invincible = false
	set_collision_mask_value(2, true)

	inv_time_left = 0.0

	if spr:
		spr.modulate.a = 1.0


# -------------------------
# SPEED BOOST
# -------------------------
func enable_speed_boost(duration: float, multiplier: float = 1.5) -> void:

	sfx_powerup.play()

	_speed_id += 1
	var my_id := _speed_id

	speed_boost = multiplier

	speed_time_left = duration
	speed_max_time = duration

	await get_tree().create_timer(duration).timeout

	if my_id != _speed_id:
		return

	speed_boost = 1.0
	speed_time_left = 0.0


# -------------------------
# INPUT
# -------------------------
func _input(event):

	if event.is_action_pressed("jump") and jumps_left > 0:
		sfx_jump.play()
		velocity.y = jump_power * jump_multiplier
		jumps_left -= 1

	if event.is_action_pressed("move_down"):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)


# -------------------------
# PHYSICS
# -------------------------
func _physics_process(delta: float) -> void:

	# --- timers ---
	if inv_time_left > 0:
		inv_time_left -= delta
		if inv_time_left < 0:
			inv_time_left = 0

	if speed_time_left > 0:
		speed_time_left -= delta
		if speed_time_left < 0:
			speed_time_left = 0

	if jump_time_left > 0:
		jump_time_left -= delta
		if jump_time_left < 0:
			jump_time_left = 0

	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# respawn
	if global_position.y > 2000:
		set_physics_process(false)
		GameManager.respawn_player()

	direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * speed * speed_multiplier * speed_boost
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			speed * speed_multiplier
		)

	move_and_slide()

	if is_on_floor():
		jumps_left = max_jumps
