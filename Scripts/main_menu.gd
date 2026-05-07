extends Control

func _ready() -> void:
	pass # Replace with function body.

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Areas/map_1.tscn")

func _on_settings_pressed() -> void:
	print("Settings")

func _on_exit_pressed() -> void:
	get_tree().quit()
