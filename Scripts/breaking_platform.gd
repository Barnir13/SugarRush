extends StaticBody2D

var triggered := false
var time := 0.0
var base_pos: Vector2

func _ready() -> void:
	$Node2D/AnimationPlayer.play("idle")
	base_pos = $Node2D/Sprite2D.position
	set_process(false)

func _process(delta: float) -> void:
	if triggered:
		time += delta
		$Node2D/Sprite2D.position = base_pos + Vector2(0, sin(time * 40.0) * 0.35) # platform rezgése

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not triggered:
		triggered = true
		$Node2D/AnimationPlayer.play("destroy")
		$Timer.start(1.2)
		set_process(true)

func _on_timer_timeout() -> void:
	queue_free()
