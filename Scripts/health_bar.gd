extends CanvasLayer

@onready var heart1 = $health_bar/heart1
@onready var heart2 = $health_bar/heart2
@onready var heart3 = $health_bar/heart3

@onready var coin_label = $Label
@onready var score_label = $score_label
@onready var time_label = $time_label
@onready var recipe_label = $recipe_label
@onready var recipe_icon = $recipe_icon

@onready var invincible_powerup_bar = $invincible_powerup_bar
@onready var speed_powerup_bar = $speed_powerup_bar
@onready var jump_powerup_bar = $jump_powerup_bar

var _pause_menu_scene = preload("res://Assets/Scenes/pause_menu.tscn")
var _pause_open := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not _pause_open:
		_pause_open = true
		get_tree().paused = true
		var menu = _pause_menu_scene.instantiate()
		menu.tree_exited.connect(func(): _pause_open = false)
		add_child(menu)

func _process(_delta: float) -> void:
	update_ui()

func update_ui() -> void:
	var l = GameManager.lives
	heart1.visible = l >= 1
	heart2.visible = l >= 2
	heart3.visible = l >= 3

	coin_label.text = str(GameManager.total_coins)
	score_label.text = "SCORE: " + "%06d" % GameManager.score
	recipe_label.text = str(GameManager.total_recipes)

	var t = int(GameManager.time_left)
	time_label.text = "TIME: " + "%03d" % t

	if GameManager.player:
		var p = GameManager.player

		invincible_powerup_bar.max_value = p.inv_max_time
		invincible_powerup_bar.value = p.inv_time_left
		invincible_powerup_bar.visible = p.inv_time_left > 0

		speed_powerup_bar.max_value = p.speed_max_time
		speed_powerup_bar.value = p.speed_time_left
		speed_powerup_bar.visible = p.speed_time_left > 0

		jump_powerup_bar.max_value = p.jump_max_time
		jump_powerup_bar.value = p.jump_time_left
		jump_powerup_bar.visible = p.jump_time_left > 0
