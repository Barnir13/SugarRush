extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "is_dying" in body and not body.is_dying:
			body.is_dying = true
			GameManager.respawn_player()
