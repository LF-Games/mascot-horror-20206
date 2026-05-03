extends HSlider

var master_bus_index = AudioServer.get_bus_index("Master")



func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index,linear_to_db(value))
