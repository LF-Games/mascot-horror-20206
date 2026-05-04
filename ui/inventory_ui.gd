class_name InventoryUI
extends Control
## Classe responsável por exibir os itens do inventário na interface

@export var ui_controller: UIController
@export var label_parent: Control
@export var label_scene: PackedScene
@export var no_items_label: Label

var en_dic = {
	"BATTERY" : "Battery",
	"GLITTER" : "Glitter",
	"FLOWER_ITEM" : "Flower",
	"CANDLES" : "Candles", 
	"DOOR_KEY" : "Door Key",
	"CANE" : "Cane",
	"LADDER" : "Ladder",
}


func _process(_delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		_toggle_display()


func _toggle_display():
	if ui_controller.current_ui == self:
		ui_controller.reset_default()
	else:
		_update_labels()
		ui_controller.request_visibility(self )


func _update_labels():
	for node in label_parent.get_children():
		node.queue_free()
	var items = GlobalState.get_inventory_list()
	for item in items:
		var new_label := label_scene.instantiate() as Label
		label_parent.add_child(new_label)
		new_label.text = "%s x%s" % [en_dic[item.key], item.amount]
	no_items_label.visible = items.size() == 0
