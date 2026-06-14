extends AnimatedSprite2D  
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_use") and not is_open:
		open_chest()

func open_chest() -> void:
	is_open = true
	anim_player.play("open")
