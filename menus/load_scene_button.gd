extends Button

@export var scene: PackedScene

func _ready():
	pressed.connect(func():
		get_tree().change_scene_to_packed(scene)
	)
