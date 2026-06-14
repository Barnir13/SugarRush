extends Control

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	GameManager.lives = GameManager.max_lives
	GameManager.total_coins = 0
	GameManager.score = 0
	GameManager.checkpoint_score = 0
	GameManager.collected_coins.clear()
	GameManager.checkpoint_collected_coins.clear()
	GameManager.checkpoint_total_coins = 0
	GameManager.has_checkpoint = false
	GameManager.checkpoint_position = Vector2.ZERO
	GameManager.emit_signal("score_changed", 0)
	get_tree().change_scene_to_file("res://Assets/Scenes/Areas/map_1.tscn")
