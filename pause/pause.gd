extends Node

@export var ui_controller: UIController
@export var pause_ui: Control
@export var pause_button: Button

func _ready() -> void:
	pause_button.pressed.connect(_on_button_pressed)


func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause"):
		_set_paused(!get_tree().paused)


func _on_button_pressed() -> void:
	_set_paused(false)


func _set_paused(value: bool):
	get_tree().paused = value
	if value:
		ui_controller.request_visibility(pause_ui)
	else:
		ui_controller.reset_default()
