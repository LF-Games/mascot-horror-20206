extends Button

@export var cutscene: String


func _ready():
	pressed.connect(func():
		get_tree().change_scene_to_file(cutscene)
	)
