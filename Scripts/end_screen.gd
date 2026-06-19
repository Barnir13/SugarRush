extends Control

@onready var score_label = $ScoreLabel
@onready var title_label = $TitleLabel

func _ready() -> void:
	GameManager.stop_timer()
	score_label.text = "SCORE: " + "%06d" % GameManager.score

func _on_main_menu_pressed() -> void:
	GameManager.lives = GameManager.max_lives
	GameManager.total_coins = 0
	GameManager.score = 0
	GameManager.checkpoint_score = 0
	GameManager.total_recipes = 0
	GameManager.checkpoint_recipes = 0
	GameManager.collected_coins.clear()
	GameManager.checkpoint_collected_coins.clear()
	GameManager.has_checkpoint = false
	GameManager.checkpoint_position = Vector2.ZERO
	GameManager.emit_signal("score_changed", 0)
	GameManager.emit_signal("recipes_changed", 0)
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
