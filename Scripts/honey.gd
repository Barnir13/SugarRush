extends AnimatedSprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	if ("invincible" in body) and body.invincible:
		return

	body.enable_honey_effect(6.0)
