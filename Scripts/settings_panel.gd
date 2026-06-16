extends Panel

signal closed()

@onready var master_slider = $VBox/MasterRow/master_slider
@onready var music_slider = $VBox/MusicRow/music_slider
@onready var master_label = $VBox/MasterRow/master_percent
@onready var music_label = $VBox/MusicRow/music_percent

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	master_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	music_slider.value = BgMusic.volume_db
	_update_labels()

func _update_labels() -> void:
	master_label.text = str(int((master_slider.value + 80) / 100.0 * 100)) + "%"
	music_label.text = str(int((music_slider.value + 100) / 120.0 * 100)) + "%"

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	master_label.text = str(int((value + 80) / 100.0 * 100)) + "%"

func _on_music_slider_value_changed(value: float) -> void:
	BgMusic.volume_db = value
	music_label.text = str(int((value + 100) / 120.0 * 100)) + "%"

func _on_close_pressed() -> void:
	emit_signal("closed")
	hide()
