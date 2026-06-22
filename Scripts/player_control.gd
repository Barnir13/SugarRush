extends CharacterBody2D
class_name Player

@export var move_speed := 125.0
@export var acceleration := 1000.0
@export var deceleration := 1500.0
@export var air_acceleration := 800.0
@export var air_deceleration := 5600.0

@export var jump_velocity := -320.0
@export var jump_cut_multiplier := 0.4

@export var gravity_multiplier := 1.0
@export var fall_gravity_multiplier := 1.8
@export var max_fall_speed := 350.0

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

var is_dying := false
var _death_velocity := Vector2.ZERO
var _death_gravity := 600.0

var honey_active := false
var honey_time_left := 0.0
var honey_max_time := 0.0
var _honey_id := 0

var last_direction := 1 # 1 = jobbra, -1 = balra
var is_jumping := false 

var _pause_menu_scene = preload("res://Assets/Scenes/pause_menu.tscn")
var _pause_open := false

@onready var spr: AnimatedSprite2D = get_node_or_null("Node2D/Sprite2D")
@onready var cam: Camera2D = get_node_or_null("Camera2D")
var _death_sprite: Sprite2D = null

@onready var sfx_powerup: AudioStreamPlayer2D = $sfx_powerup
@onready var sfx_jump: AudioStreamPlayer2D = $sfx_jump

func _ready() -> void:
	get_tree().paused = false
	GameManager._is_respawning = false

	add_to_group("Player")
	jumps_left = max_jumps
	is_dying = false
	is_jumping = false

	if GameManager.has_checkpoint:
		global_position = GameManager.checkpoint_position

	GameManager.set_player(self)
	GameManager.start_timer()

	if cam:
		cam.reset_smoothing()
		cam.position_smoothing_enabled = false

func reset_powerups():
	max_jumps = 1
	jumps_left = 1
	invincible = false
	set_collision_mask_value(2, true)
	speed_boost = 1.0
	honey_active = false
	inv_time_left = 0.0
	speed_time_left = 0.0
	jump_time_left = 0.0
	honey_time_left = 0.0
	if spr:
		spr.modulate = Color(1, 1, 1, 1)

func enable_honey_effect(duration: float) -> void:
	_honey_id += 1
	var my_id := _honey_id
	honey_active = true
	honey_time_left = duration
	honey_max_time = duration
	if spr:
		spr.modulate = Color(1.0, 0.85, 0.2, 1.0)
	await get_tree().create_timer(duration).timeout
	if my_id != _honey_id:
		return
	honey_active = false
	honey_time_left = 0.0
	if spr:
		spr.modulate = Color(1, 1, 1, 1)

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
	if event.is_action_pressed("pause") and not _pause_open:
		_pause_open = true
		var menu = _pause_menu_scene.instantiate()
		menu.tree_exited.connect(func(): _pause_open = false)
		get_tree().current_scene.add_child(menu)
		return

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
	if is_dying and _death_sprite != null:
		_death_velocity.y += _death_gravity * delta
		global_position += _death_velocity * delta
		return
	if is_dying:
		return

	update_timers(delta)

	if global_position.y > 2000:
		is_dying = true
		GameManager.respawn_player()
		return

	if not is_on_floor():
		var gravity = get_gravity().y * gravity_multiplier
		if velocity.y > 0:
			gravity *= fall_gravity_multiplier
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	if is_on_floor():
		coyote_timer = coyote_time
		jumps_left = max_jumps
		is_jumping = false
	else:
		coyote_timer -= delta

	# ✅ 1. LEKÉRDEZZÜK AZ IRÁNYT MINDENNÉL ELŐBB (Hogy az ugrás gomb lenyomásakor már tökéletes legyen)
	if honey_active:
		direction = Input.get_axis("move_right", "move_left")
	else:
		direction = Input.get_axis("move_left", "move_right")

	# ✅ 2. AZONNAL FRISSÍTJÜK A NÉZÉSI IRÁNYT
	if direction > 0:
		last_direction = 1
	elif direction < 0:
		last_direction = -1

	# ✅ 3. CSAK EZUTÁN JÖN AZ UGRÁS INDÍTÁSA
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0:
		if coyote_timer > 0:
			do_jump()
		elif jumps_left > 0:
			do_jump()

	var honey_slow := 0.4 if honey_active else 1.0
	var target_speed = direction * move_speed * speed_boost * honey_slow

	if is_on_floor():
		if direction != 0:
			velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	else:
		if direction != 0:
			velocity.x = move_toward(velocity.x, target_speed, air_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_deceleration * delta)

	move_and_slide()

	_update_animation()

func _update_animation() -> void:
	if not spr:
		return

	# ✅ Ha ugrásban van, ráfagyasztjuk a kezdő ugrási animációt, kormányzáskor nem engedjük felülírni
	if is_jumping:
		if spr.animation == "jump_right" or spr.animation == "jump_left":
			return
		
		if last_direction > 0:
			spr.play("jump_right")
		else:
			spr.play("jump_left")
		return

	# Sima földi animációk
	if direction > 0:
		spr.play("walk_right")
	elif direction < 0:
		spr.play("walk_left")
	else:
		if last_direction > 0:
			spr.play("idle_right")
		else:
			spr.play("idle_left")

func do_jump():
	sfx_jump.play()
	velocity.y = jump_velocity
	jump_buffer_timer = 0
	coyote_timer = 0
	jumps_left -= 1
	is_jumping = true

	# Azonnali kényszerítés az elrugaszkodás szent pillanatában
	if spr:
		if last_direction > 0:
			spr.play("jump_right")
		else:
			spr.play("jump_left")

func die_from_enemy() -> void:
	if is_dying:
		return
	is_dying = true

	collision_layer = 0
	collision_mask = 0

	set_physics_process(false)
	set_process_input(false)

	if cam:
		cam.reparent(get_tree().current_scene)

	_death_sprite = Sprite2D.new()
	_death_sprite.texture = load("res://Sprites/player/player_death.png")
	_death_sprite.z_index = 10
	add_child(_death_sprite)

	if spr:
		spr.visible = false

	_death_velocity = Vector2(0, -200)

	set_physics_process(true)

	await get_tree().create_timer(2.2).timeout
	GameManager.respawn_player()

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
	if honey_time_left > 0:
		honey_time_left -= delta
		if honey_time_left < 0:
			honey_time_left = 0
