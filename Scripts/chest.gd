extends AnimatedSprite2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false
var player_nearby: bool = false

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_use") and not is_open and player_nearby:
		open_chest()

func open_chest() -> void:
	is_open = true
	anim_player.play("open")
	GameManager.add_recipe()
	_spawn_effect()

func _spawn_effect() -> void:
	# "+1 Recipe!" szöveg felfelé lebeg és elfakul
	var label = Label.new()
	label.text = "+1 Recipe!"
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.1, 1.0))
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.position = Vector2(-20, -30)
	label.z_index = 10
	add_child(label)

	# Tween: felfelé mozog + elfakul
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", -60.0, 1.2).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 1.2).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(label.queue_free)

	# Kis "burst" körök – 4 szikra
	for i in range(4):
		var spark = ColorRect.new()
		spark.size = Vector2(4, 4)
		var angle = i * PI / 2.0
		spark.position = Vector2(cos(angle) * 12, sin(angle) * 12) - Vector2(2, 2)
		spark.color = Color(1.0, 0.85, 0.1, 1.0)
		spark.z_index = 10
		add_child(spark)

		var st = create_tween()
		st.set_parallel(true)
		st.tween_property(spark, "position", spark.position + Vector2(cos(angle) * 20, sin(angle) * 20), 0.5)
		st.tween_property(spark, "modulate:a", 0.0, 0.5)
		st.chain().tween_callback(spark.queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = false
