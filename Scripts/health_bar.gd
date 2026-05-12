extends CanvasLayer

@onready var heart1 = $health_bar/heart1
@onready var heart2 = $health_bar/heart2
@onready var heart3 = $health_bar/heart3

@onready var coin_label = $Label

@onready var invincible_powerup_bar = $invincible_powerup_bar
@onready var speed_powerup_bar = $speed_powerup_bar
@onready var jump_powerup_bar = $jump_powerup_bar


func _process(_delta: float) -> void:
	update_ui()


func update_ui() -> void:

	# --- HP ---
	var l = GameManager.lives

	heart1.visible = l >= 1
	heart2.visible = l >= 2
	heart3.visible = l >= 3

	# --- Coins ---
	coin_label.text = str(GameManager.total_coins)

	if GameManager.player:
		var p = GameManager.player

		# 🍩 DONUT (invincibility)
		invincible_powerup_bar.max_value = p.inv_max_time
		invincible_powerup_bar.value = p.inv_time_left
		invincible_powerup_bar.visible = p.inv_time_left > 0

		# ⚡ SPEED
		speed_powerup_bar.max_value = p.speed_max_time
		speed_powerup_bar.value = p.speed_time_left
		speed_powerup_bar.visible = p.speed_time_left > 0

		# 🦘 DOUBLE JUMP
		jump_powerup_bar.max_value = p.jump_max_time
		jump_powerup_bar.value = p.jump_time_left
		jump_powerup_bar.visible = p.jump_time_left > 0
