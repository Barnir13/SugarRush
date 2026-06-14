extends Area2D

@export var duration := 5.0

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		body.enable_double_jump(duration)
		GameManager.add_score(300)
		queue_free()
