extends Area2D

@export var speed := 150.0
var direction := Vector2.RIGHT

func _physics_process(delta):

	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("die_from_enemy"):
			body.die_from_enemy()
		else:
			GameManager.respawn_player()

	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
