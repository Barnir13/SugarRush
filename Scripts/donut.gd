extends Node2D

@export var duration := 5.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	if body.has_method("enable_invincibility"):
		body.enable_invincibility(duration)

	GameManager.add_score(300)
	queue_free()
