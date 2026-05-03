extends Node

@export var timeline_name: String
@export var next_scene: PackedScene

func _ready():
	Dialogic.start(timeline_name)
	if next_scene:
		await Dialogic.timeline_ended
		get_tree().change_scene_to_packed(next_scene)