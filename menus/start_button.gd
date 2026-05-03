extends Button

@export var cutscene_scene: PackedScene


func _ready():
	pressed.connect(func():
		get_tree().change_scene_to_packed(cutscene_scene)
	)
