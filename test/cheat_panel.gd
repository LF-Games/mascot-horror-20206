extends PanelContainer

@export var canvas_modulate: CanvasModulate
@export var items: Array[String]
@export var monsters: Array[Node]

func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_reveal_map_button_pressed():
	canvas_modulate.color = Color.WHITE


func _on_kill_monsters_button_pressed():
	for monster in monsters:
		monster.queue_free()

func _on_get_items_button_pressed():
	for item in items:
		GlobalState.add_inventory_item(item)


func _input(event):
	if event.is_action_pressed("cheat_panel"):
		visible = !visible