class_name UIController
extends Node
## Node responsavel por alternar a interface exibida atualmente

@export var default_ui: Control
var current_ui: Control


func _ready():
	current_ui = default_ui
	current_ui.show()
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	GameManager.player_died.connect(_on_game_over)


func request_visibility(node: Control):
	current_ui.hide()
	current_ui = node
	node.show()


func reset_default():
	current_ui.hide()
	current_ui = default_ui
	default_ui.show()


func _on_timeline_started():
	current_ui.hide()


func _on_timeline_ended():
	current_ui.show()


func _on_game_over():
	current_ui.hide()