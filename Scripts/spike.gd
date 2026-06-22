extends Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	if ("invincible" in body) and body.invincible:
		return

	if "health" in body:
		body.health -= 1
		if body.health > 0:
			return

	if body.has_method("die_from_enemy"):
		body.die_from_enemy() 
	else:
		GameManager.respawn_player()
