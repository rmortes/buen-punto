extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sfx_index= AudioServer.get_bus_index("Space")
	value = (10 ** (AudioServer.get_bus_volume_db(sfx_index) / 240)) * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func logWithBase(value, base): return log(value) / log(base)

func _on_value_changed(value: float) -> void:
	var sfx_index= AudioServer.get_bus_index("Space")
	AudioServer.set_bus_volume_db(sfx_index, logWithBase(value / 100, 10)*60-60)
