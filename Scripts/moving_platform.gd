extends Path2D
class_name MovingPlatform

@export var path_time: float = 3.0
@export var ease_type := Tween.EASE_IN_OUT
@export var transition_type := Tween.TRANS_SINE
@export var path_follow_2D: PathFollow2D

func _ready() -> void:
	if path_follow_2D == null:
		path_follow_2D = get_node_or_null("PathFollow2D") as PathFollow2D

	if path_follow_2D == null:
		push_error("MovingPlatform: nincs PathFollow2D beállítva!")
		return

	move_tween()

func move_tween() -> void:
	# ✅ sose legyen 0, különben infinite loop warning jön
	path_time = max(path_time, 0.01)

	var tween := get_tree().create_tween()
	tween.set_loops() # végtelen

	tween.tween_property(path_follow_2D, "progress_ratio", 1.0, path_time)\
		.set_ease(ease_type).set_trans(transition_type)

	tween.tween_property(path_follow_2D, "progress_ratio", 0.0, path_time)\
		.set_ease(ease_type).set_trans(transition_type)
