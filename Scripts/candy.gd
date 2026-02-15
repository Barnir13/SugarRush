extends Node2D

@export var duration := 5.0
@export var boost_multiplier := 1.5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("enable_speed_boost"):
			body.enable_speed_boost(duration, boost_multiplier)
		queue_free()
