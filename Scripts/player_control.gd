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

@onready var spr: Sprite2D = get_node_or_null("Node2D/Sprite2D") # ha van, tudunk effektet adni

func respawn():
	self.global_position = Vector2(89,-91.62)

func _ready() -> void:
	add_to_group("Player")
	jumps_left = max_jumps

func enable_double_jump(duration: float) -> void:
	_powerup_id += 1
	var my_id := _powerup_id

	max_jumps = 2
	jumps_left = min(jumps_left, max_jumps)

	await get_tree().create_timer(duration).timeout
	if my_id != _powerup_id:
		return

	max_jumps = 1
	jumps_left = min(jumps_left, max_jumps)

func enable_invincibility(duration: float) -> void:
	_inv_id += 1
	var my_id := _inv_id

	invincible = true
	if spr:
		spr.modulate.a = 0.6

	await get_tree().create_timer(duration).timeout
	if my_id != _inv_id:
		return

	invincible = false
	if spr:
		spr.modulate.a = 1.0

func enable_speed_boost(duration: float, multiplier: float = 1.5) -> void:
	_speed_id += 1
	var my_id := _speed_id

	speed_boost = multiplier

	await get_tree().create_timer(duration).timeout
	if my_id != _speed_id:
		return

	speed_boost = 1.0

func _input(event):
	if event.is_action_pressed("jump") and jumps_left > 0:
		velocity.y = jump_power * jump_multiplier
		jumps_left -= 1

	if event.is_action_pressed("move_down"):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * speed * speed_multiplier * speed_boost
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier) # fékezés marad alap

	move_and_slide()

	if is_on_floor():
		jumps_left = max_jumps
