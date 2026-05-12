extends Area2D

@export var coin_id: String = ""
@export var value: int = 1

@onready var sfx_coin: AudioStreamPlayer2D = $sfx_coin


func _ready() -> void:

	# automatikus ID ha nincs megadva
	if coin_id.is_empty():
		coin_id = str(get_path())

	body_entered.connect(_on_body_entered)

	# ha már fel lett véve korábban
	if GameManager.collected_coins.has(coin_id):
		queue_free()


func _on_body_entered(body: Node2D) -> void:

	if not body.is_in_group("Player"):
		return

	# dupla trigger védelem
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

	GameManager.add_coin(coin_id, value)

	visible = false

	if sfx_coin.stream:
		sfx_coin.play()
		await sfx_coin.finished

	queue_free()
