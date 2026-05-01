extends Node

var checkpoint_position : Vector2
var has_checkpoint := false

var player : Player
var start_position : Vector2

func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	start_position = player.global_position
	
func respawn_player():
	if player == null:
		return

	if has_checkpoint:
		player.global_position = checkpoint_position
	else:
		player.global_position = start_position

	player.velocity = Vector2.ZERO
