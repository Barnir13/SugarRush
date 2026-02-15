extends Area2D

@export var duration := 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		body.enable_double_jump(duration)
		queue_free()
