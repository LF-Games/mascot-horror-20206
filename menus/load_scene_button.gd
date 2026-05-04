extends Button

@export var scene: String

func _ready():
	pressed.connect(func():
		get_tree().change_scene_to_file(scene)
	)
