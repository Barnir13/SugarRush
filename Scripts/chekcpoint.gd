extends Node2D

class_name Checkpoint

var activated = false

@onready var sfx_checkpoint: AudioStreamPlayer2D = $sfx_checkpoint


func activate():
	GameManager.checkpoint_position = global_position
	GameManager.has_checkpoint = true
	
	# ÚJ: Megkérjük a GameManager-t, hogy mentse el a pontokat és az érméket!
	GameManager.save_checkpoint()
	
	activated = true
	$AnimationPlayer.play("active")
	sfx_checkpoint.play()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and !activated:
		activate()
