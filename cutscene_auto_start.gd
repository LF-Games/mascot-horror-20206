extends Node

@export var timeline_name: String
@export var next_scene: PackedScene
@export var check_flag: String

func _ready():
	if check_flag != null and check_flag.strip_edges() != "" and GlobalState.get_flag(check_flag):
		return
	Dialogic.start(timeline_name)
	await Dialogic.timeline_ended
	if check_flag != null and check_flag.strip_edges() != "":
		GlobalState.set_flag(check_flag)
		GlobalState.save_state()
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
