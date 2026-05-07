extends Node

var checkpoint_position : Vector2
var has_checkpoint := false

var player : Player


func set_player(p):
	player = p

func respawn_player():

	if player == null:
		return

	get_tree().call_deferred("reload_current_scene")
