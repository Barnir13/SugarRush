extends Node2D

@export var duration := 5.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("enable_invincibility"):
			body.enable_invincibility(duration)
		queue_free()
