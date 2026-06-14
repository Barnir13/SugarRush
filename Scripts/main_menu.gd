extends Control

@onready var settings_panel = $settings_panel

func _ready() -> void:
	settings_panel.hide()
	settings_panel.closed.connect(func(): settings_panel.hide())

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Areas/map_1.tscn")

func _on_settings_pressed() -> void:
	settings_panel.show()

func _on_exit_pressed() -> void:
	get_tree().quit()
