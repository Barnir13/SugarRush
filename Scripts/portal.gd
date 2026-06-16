extends Area2D

@export var next_map: String = ""

var player_inside := false

@onready var prompt_label = $PromptLabel

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("open_use"):
		if next_map != "":
			GameManager.add_time_bonus()
			GameManager.save_checkpoint()
			GameManager.has_checkpoint = false
			get_tree().change_scene_to_file(next_map)

func _on_body_entered(body):
	if body is Player:
		player_inside = true
		prompt_label.visible = true

func _on_body_exited(body):
	if body is Player:
		player_inside = false
		prompt_label.visible = false
