extends Node

signal lives_changed

var checkpoint_position: Vector2
var has_checkpoint := false

var total_coins: int = 0

var max_lives := 3
var lives := 3

# CURRENT RUN
var collected_coins := {}

# CHECKPOINT SAVE
var checkpoint_collected_coins := {}
var checkpoint_total_coins := 0

var player: Player


func set_player(p) -> void:
	player = p


func add_coin(coin_id: String, value: int = 1) -> void:
	if collected_coins.has(coin_id):
		return

	collected_coins[coin_id] = true
	total_coins += value


func save_checkpoint() -> void:
	checkpoint_collected_coins = collected_coins.duplicate()
	checkpoint_total_coins = total_coins


func respawn_player() -> void:
	if player == null:
		return

	lives -= 1
	emit_signal("lives_changed")

	if lives <= 0:
		lives = max_lives
		total_coins = 0

		collected_coins.clear()
		checkpoint_collected_coins.clear()

		has_checkpoint = false
		checkpoint_position = Vector2.ZERO

	else:
		# 🔥 EZ A FONTOS FIX
		collected_coins = checkpoint_collected_coins.duplicate()
		total_coins = checkpoint_total_coins

	get_tree().call_deferred("reload_current_scene")
