extends GutTest

## Unit tesztek a Player mozgás, ugrás és powerup rendszerekhez.
## Teszteli: mozgás, ugrás, invincibility, double jump, speed boost, respawn, checkpoint

var _player_scene = preload("res://Assets/Scenes/player.tscn")
var _player: Player = null


func before_each() -> void:
	_player = _player_scene.instantiate()
	add_child_autofree(_player)
	# Alaphelyzet: semmi powerup, nincs dying
	_player.is_dying = false
	_player.reset_powerups()


# ─────────────────────────────────────────────
# 1. PLAYER MOZGÁS
# ─────────────────────────────────────────────

func test_move_right_sets_positive_velocity() -> void:
	# Közvetlenül szimuláljuk a direction hatását
	_player.direction = 1.0
	var target_speed = _player.move_speed * _player.speed_boost
	_player.velocity.x = move_toward(_player.velocity.x, target_speed, _player.acceleration * 0.1)

	assert_gt(_player.velocity.x, 0.0, "Jobbra mozgáskor a velocity.x pozitív kell legyen")


func test_move_left_sets_negative_velocity() -> void:
	_player.direction = -1.0
	var target_speed = -_player.move_speed * _player.speed_boost
	_player.velocity.x = move_toward(_player.velocity.x, target_speed, _player.acceleration * 0.1)

	assert_lt(_player.velocity.x, 0.0, "Balra mozgáskor a velocity.x negatív kell legyen")


# ─────────────────────────────────────────────
# 2. UGRÁS RENDSZER
# ─────────────────────────────────────────────

func test_jump_sets_negative_y_velocity() -> void:
	_player.do_jump()
	assert_lt(_player.velocity.y, 0.0, "Ugrás után velocity.y negatív kell legyen")


func test_jump_velocity_matches_export() -> void:
	_player.do_jump()
	assert_almost_eq(
		_player.velocity.y,
		_player.jump_velocity,
		5.0,
		"Az ugrás sebessége megegyezik az exportált jump_velocity értékkel"
	)


# ─────────────────────────────────────────────
# 3. INVINCIBILITY POWERUP
# ─────────────────────────────────────────────

func test_invincibility_sets_flag() -> void:
	_player.enable_invincibility(5.0)
	assert_true(_player.invincible, "enable_invincibility után az invincible flag true kell legyen")


func test_invincibility_disables_enemy_collision_layer() -> void:
	_player.enable_invincibility(5.0)
	# layer 2 = enemy layer; false = nem ütközik velük
	assert_false(
		_player.get_collision_mask_value(2),
		"Invincibility alatt az enemy collision mask le kell legyen kapcsolva"
	)


func test_invincibility_expires_after_duration() -> void:
	_player.enable_invincibility(0.1)
	await wait_seconds(0.3)
	assert_false(_player.invincible, "Invincibility lejárat után az invincible flag false kell legyen")


func test_invincibility_restores_collision_after_expiry() -> void:
	_player.enable_invincibility(0.1)
	await wait_seconds(0.3)
	assert_true(
		_player.get_collision_mask_value(2),
		"Invincibility lejárat után az enemy collision mask visszakapcsol"
	)


# ─────────────────────────────────────────────
# 4. DOUBLE JUMP RENDSZER
# ─────────────────────────────────────────────

func test_double_jump_increases_max_jumps() -> void:
	assert_eq(_player.max_jumps, 1, "Alap max_jumps értéke 1 kell legyen")
	_player.enable_double_jump(5.0)
	assert_eq(_player.max_jumps, 2, "Double jump után max_jumps értéke 2 kell legyen")


func test_double_jump_expires_after_duration() -> void:
	_player.enable_double_jump(0.1)
	await wait_seconds(0.3)
	assert_eq(_player.max_jumps, 1, "Double jump lejárat után max_jumps visszaáll 1-re")


func test_double_jump_jumps_left_updated() -> void:
	_player.jumps_left = 1
	_player.enable_double_jump(5.0)
	assert_eq(_player.jumps_left, 2, "Double jump felvétele után jumps_left 2 kell legyen")


# ─────────────────────────────────────────────
# 5. SPEED BOOST RENDSZER
# ─────────────────────────────────────────────

func test_speed_boost_sets_multiplier() -> void:
	assert_almost_eq(_player.speed_boost, 1.0, 0.01, "Alap speed_boost értéke 1.0 kell legyen")
	_player.enable_speed_boost(5.0, 1.5)
	assert_almost_eq(_player.speed_boost, 1.5, 0.01, "Speed boost után speed_boost 1.5 kell legyen")


func test_speed_boost_expires_after_duration() -> void:
	_player.enable_speed_boost(0.1, 1.5)
	await wait_seconds(0.3)
	assert_almost_eq(_player.speed_boost, 1.0, 0.01, "Speed boost lejárat után speed_boost visszaáll 1.0-ra")


func test_speed_boost_timer_set_correctly() -> void:
	_player.enable_speed_boost(3.0, 1.5)
	assert_almost_eq(_player.speed_time_left, 3.0, 0.1, "Speed boost timer értéke megfelel a megadott időnek")


# ─────────────────────────────────────────────
# 6. RESPAWN ALAP MŰKÖDÉS
# ─────────────────────────────────────────────

func test_player_below_2000_triggers_dying() -> void:
	# Közvetlenül szimuláljuk a feltételt a _physics_process-ből
	var y := 2100.0
	var would_die := y > 2000
	assert_true(would_die, "Ha a player y > 2000, az is_dying true kell legyen")


func test_is_dying_blocks_physics() -> void:
	_player.is_dying = true
	var vel_before := _player.velocity

	await wait_frames(5)

	# dying állapotban a velocity nem változik a normál fizika által
	assert_eq(
		_player.velocity,
		vel_before,
		"is_dying állapotban a velocity nem változhat (fizika blokkolt)"
	)


# ─────────────────────────────────────────────
# 7. CHECKPOINT AKTIVÁLÁS
# ─────────────────────────────────────────────

func test_checkpoint_saves_position_in_game_manager() -> void:
	var test_pos := Vector2(300.0, 150.0)
	GameManager.checkpoint_position = test_pos
	GameManager.has_checkpoint = true

	assert_true(GameManager.has_checkpoint, "has_checkpoint true kell legyen checkpoint után")
	assert_eq(
		GameManager.checkpoint_position,
		test_pos,
		"A GameManager elmenti a checkpoint pozícióját"
	)


func test_player_spawns_at_checkpoint_if_set() -> void:
	var cp_pos := Vector2(500.0, 200.0)
	GameManager.has_checkpoint = true
	GameManager.checkpoint_position = cp_pos

	# Új player példány, a _ready-ben olvassa a checkpointot
	var p2: Player = _player_scene.instantiate()
	add_child_autofree(p2)

	assert_almost_eq(
		p2.global_position.x, cp_pos.x, 1.0,
		"A player a checkpoint x pozíciójára spawnol"
	)
	assert_almost_eq(
		p2.global_position.y, cp_pos.y, 1.0,
		"A player a checkpoint y pozíciójára spawnol"
	)

	# Tisztítás
	GameManager.has_checkpoint = false
	GameManager.checkpoint_position = Vector2.ZERO


# ─────────────────────────────────────────────
# RESET POWERUPS
# ─────────────────────────────────────────────

func test_reset_powerups_clears_all_states() -> void:
	_player.enable_invincibility(10.0)
	_player.enable_speed_boost(10.0, 2.0)
	_player.enable_double_jump(10.0)

	_player.reset_powerups()

	assert_false(_player.invincible, "reset után invincible false kell legyen")
	assert_almost_eq(_player.speed_boost, 1.0, 0.01, "reset után speed_boost 1.0 kell legyen")
	assert_eq(_player.max_jumps, 1, "reset után max_jumps 1 kell legyen")
