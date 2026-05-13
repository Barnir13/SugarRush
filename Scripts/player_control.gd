extends CharacterBody2D
class_name Player

@export var move_speed := 320.0
@export var acceleration := 1800.0
@export var deceleration := 2200.0
@export var air_acceleration := 1200.0
@export var air_deceleration := 1000.0

@export var jump_velocity := -320.0
@export var jump_cut_multiplier := 0.45

@export var gravity_multiplier := 1.0
@export var fall_gravity_multiplier := 1.8
@export var max_fall_speed := 900.0

@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12

var direction := 0.0
var coyote_timer := 0.0
var jump_buffer_timer := 0.0

var max_jumps := 1
var jumps_left := 1
var _powerup_id := 0

var invincible := false
var _inv_id := 0

var speed_boost := 1.0
var _speed_id := 0

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

func enable_double_jump(duration: float) -> void:
	sfx_powerup.play()

	_powerup_id += 1
	var my_id := _powerup_id

	max_jumps = 2
	jumps_left = min(jumps_left + 1, max_jumps)

	jump_time_left = duration
	jump_max_time = duration

	await get_tree().create_timer(duration).timeout

	if my_id != _powerup_id:
		return

	max_jumps = 1
	jumps_left = min(jumps_left, max_jumps)

	jump_time_left = 0.0

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

func _input(event):
	if event.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if event.is_action_released("jump"):
		if velocity.y < 0:
			velocity.y *= jump_cut_multiplier

	if event.is_action_pressed("move_down"):
		set_collision_mask_value(10, false)

	if event.is_action_released("move_down"):
		set_collision_mask_value(10, true)

func _physics_process(delta: float) -> void:
	update_timers(delta)

	if global_position.y > 2000:
		set_physics_process(false)
		GameManager.respawn_player()

	if not is_on_floor():
		var gravity = get_gravity().y * gravity_multiplier

		if velocity.y > 0:
			gravity *= fall_gravity_multiplier

		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	if is_on_floor():
		coyote_timer = coyote_time
		jumps_left = max_jumps
	else:
		coyote_timer -= delta

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0:
		if coyote_timer > 0:
			do_jump()
		elif jumps_left > 0:
			do_jump()

	direction = Input.get_axis("move_left", "move_right")

	var target_speed = direction * move_speed * speed_boost

	if is_on_floor():
		if direction != 0:
			velocity.x = move_toward(
				velocity.x,
				target_speed,
				acceleration * delta
			)
		else:
			velocity.x = move_toward(
				velocity.x,
				0,
				deceleration * delta
			)
	else:
		if direction != 0:
			velocity.x = move_toward(
				velocity.x,
				target_speed,
				air_acceleration * delta
			)
		else:
			velocity.x = move_toward(
				velocity.x,
				0,
				air_deceleration * delta
			)

	move_and_slide()

func do_jump():
	sfx_jump.play()

	velocity.y = jump_velocity

	jump_buffer_timer = 0
	coyote_timer = 0

	jumps_left -= 1

func update_timers(delta):
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
