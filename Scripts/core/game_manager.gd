extends Node
signal lives_changed
signal score_changed(new_score: int)
signal recipes_changed(new_count: int)

var checkpoint_position: Vector2
var has_checkpoint := false
var total_coins: int = 0
var total_recipes: int = 0
var max_lives := 3
var lives := 3
var score: int = 0
var checkpoint_score: int = 0
var collected_coins := {}
var checkpoint_collected_coins := {}
var checkpoint_total_coins := 0
var checkpoint_recipes := 0
var player: Player

var _is_respawning := false

var time_left: float = 240.0
var timer_running: bool = false
var _time_expired := false

var _portal_sfx_player: AudioStreamPlayer
var _portal_sound := preload("res://Sounds/portal.mp3")

var _death_sfx_player: AudioStreamPlayer
var _death_sound := preload("res://Sounds/death.mp3")

func _ready() -> void:
	_portal_sfx_player = AudioStreamPlayer.new()
	_portal_sfx_player.stream = _portal_sound
	_portal_sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_portal_sfx_player)

	_death_sfx_player = AudioStreamPlayer.new()
	_death_sfx_player.stream = _death_sound
	_death_sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_death_sfx_player)

func play_portal_sound() -> void:
	_portal_sfx_player.play()
	
func play_death_sound() -> void:
	_death_sfx_player.play()

func set_player(p) -> void:
	player = p

func start_timer() -> void:
	time_left = 240.0
	timer_running = true
	_time_expired = false

func stop_timer() -> void:
	timer_running = false

func add_time_bonus() -> void:
	stop_timer()
	var bonus = int(time_left) * 10
	add_score(bonus)

func _process(delta: float) -> void:
	if timer_running and time_left > 0:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			timer_running = false
			if not _time_expired:
				_time_expired = true
				respawn_player()

func add_coin(coin_id: String, value: int = 1) -> void:
	if collected_coins.has(coin_id):
		return
	collected_coins[coin_id] = true
	total_coins += value
	add_score(200)

func add_recipe() -> void:
	total_recipes += 1
	add_score(500)
	emit_signal("recipes_changed", total_recipes)

func add_score(amount: int) -> void:
	score += amount
	emit_signal("score_changed", score)

func save_checkpoint() -> void:
	checkpoint_collected_coins = collected_coins.duplicate()
	checkpoint_total_coins = total_coins
	checkpoint_score = score
	checkpoint_recipes = total_recipes

func respawn_player() -> void:
	if _is_respawning:
		return
	_is_respawning = true

	lives -= 1
	emit_signal("lives_changed")

	if lives <= 0:
		total_coins = 0
		score = 0
		checkpoint_score = 0
		total_recipes = 0
		checkpoint_recipes = 0
		collected_coins.clear()
		checkpoint_collected_coins.clear()
		has_checkpoint = false
		checkpoint_position = Vector2.ZERO
		emit_signal("score_changed", 0)
		emit_signal("recipes_changed", 0)
		_is_respawning = false
		get_tree().paused = false
		get_tree().call_deferred("change_scene_to_file", "res://Assets/Scenes/game_over.tscn")
	else:
		score = checkpoint_score
		total_coins = checkpoint_total_coins
		total_recipes = checkpoint_recipes
		collected_coins = checkpoint_collected_coins.duplicate()
		emit_signal("score_changed", score)
		emit_signal("recipes_changed", total_recipes)
		get_tree().call_deferred("reload_current_scene")
		await get_tree().process_frame
		BgMusic.play()
		_is_respawning = false
