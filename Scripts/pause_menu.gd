extends Control

@onready var settings_panel = $settings_panel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	settings_panel.hide()
	settings_panel.closed.connect(func(): settings_panel.hide())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_on_resume_pressed()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_new_game_pressed() -> void:
	get_tree().paused = false
	GameManager.lives = GameManager.max_lives
	GameManager.total_coins = 0
	GameManager.score = 0
	GameManager.checkpoint_score = 0
	GameManager.collected_coins.clear()
	GameManager.checkpoint_collected_coins.clear()
	GameManager.has_checkpoint = false
	GameManager.checkpoint_position = Vector2.ZERO
	GameManager.emit_signal("score_changed", 0)
	get_tree().change_scene_to_file("res://Assets/Scenes/Areas/map_1.tscn")

func _on_options_pressed() -> void:
	settings_panel.show()

func _on_exit_pressed() -> void:
	get_tree().quit()
