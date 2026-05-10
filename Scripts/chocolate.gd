extends Node2D

@export var bullet : PackedScene

@onready var marker: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready():

	timer.timeout.connect(shoot)

	visible_on_screen_notifier_2d.screen_entered.connect(_on_screen_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)

	timer.stop()


func _on_screen_entered():
	timer.start()


func _on_screen_exited():
	timer.stop()


func shoot():

	var new_bullet = bullet.instantiate()

	get_tree().current_scene.add_child(new_bullet)

	new_bullet.global_position = marker.global_position

	new_bullet.direction = Vector2.LEFT
