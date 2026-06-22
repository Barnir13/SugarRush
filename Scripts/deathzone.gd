extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "is_dying" in body and not body.is_dying:
			if body.has_method("die_from_enemy"):
				body.die_from_enemy() 
			else:
				body.is_dying = true
				GameManager.respawn_player()
