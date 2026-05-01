extends Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	# ✅ Invincibility check (donut)
	# Ha van invincible változója és épp halhatatlan, ne történjen semmi
	if ("invincible" in body) and body.invincible:
		return

	# Sebzés / halál
	if "health" in body:
		body.health -= 1
		if body.health > 0:
			return

	GameManager.respawn_player()
