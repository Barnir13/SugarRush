extends AnimatedSprite2D  
# Referencia az AnimationPlayer-re
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Flag, hogy a láda már nyitva van-e
var is_open: bool = false

func _process(delta: float) -> void:
	# Ellenőrizzük az inputot minden frame-ben
	if Input.is_action_just_pressed("open_use") and not is_open:
		open_chest()

func open_chest() -> void:
	is_open = true
	anim_player.play("open")
