extends Area2D

@export var next_map: String = ""
@export var prompt_text: String = ""

var player_inside := false

@onready var prompt_label = $PromptLabel

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Ha nincs egyedi szöveg, alapértelmezett
	if prompt_text == "":
		if next_map == "":
			prompt_text = "Press E to claim\nyour sweet victory!"
		else:
			prompt_text = "Press E to go to\nthe next level"
	prompt_label.text = prompt_text

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("open_use"):
		GameManager.add_time_bonus()
		GameManager.save_checkpoint()
		GameManager.has_checkpoint = false
		if next_map != "":
			GameManager.play_portal_sound()
			get_tree().change_scene_to_file(next_map)
		else:
			get_tree().change_scene_to_file("res://Assets/Scenes/end_screen.tscn")

func _on_body_entered(body):
	if body is Player:
		player_inside = true
		prompt_label.visible = true

func _on_body_exited(body):
	if body is Player:
		player_inside = false
		prompt_label.visible = false
