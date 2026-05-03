extends TextureRect

@export var slider : HSlider
@export var on_texture : Texture
@export var off_texture : Texture


func _ready() -> void:
	slider.value_changed.connect(_on_value_changed)


func _on_value_changed(value):
	if slider.value == 0:
		texture = off_texture
	else:
		texture = on_texture
	
