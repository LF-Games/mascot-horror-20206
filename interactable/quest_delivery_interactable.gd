extends Interactable

const candle_item_key := "CANDLES"
const glitter_item_key := "GLITTER"
const red_paint_item_key := "RED_PAINT"
const candle_delivered_flag := "CANDLES_RETURNED"
const glitter_delivered_flag := "GLITTER_RETURNED"
const red_paint_delivered_flag := "RED_PAINT_RETURNED"
@export var glitter_amount := 3
@export var no_delivery_timeline := ""
@export var candles_delivery_timeline := ""
@export var glitter_delivery_timeline := ""
@export var red_paint_delivery_timeline := ""
@export var final_timeline := ""
@export var candles_sprite: Node2D
@export var glitter_sprite: Node2D
@export var red_paint_sprite: Node2D


func _ready():
	super ()
	candles_sprite.visible = GlobalState.get_flag(candle_delivered_flag)
	glitter_sprite.visible = GlobalState.get_flag(glitter_delivered_flag)
	red_paint_sprite.visible = GlobalState.get_flag(red_paint_delivered_flag)


func interact():
	if !GlobalState.get_flag(candle_delivered_flag) and GlobalState.has_inventory_item(candle_item_key):
		candles_sprite.show()
		Dialogic.start(candles_delivery_timeline)
		GlobalState.remove_intentory_item(candle_item_key)
		GlobalState.set_flag(candle_delivered_flag)
		GlobalState.save_state()
	elif !GlobalState.get_flag(glitter_delivered_flag) and GlobalState.get_item_count(glitter_item_key) >= glitter_amount:
		glitter_sprite.show()
		Dialogic.start(glitter_delivery_timeline)
		GlobalState.remove_intentory_item(glitter_item_key, 3)
		GlobalState.set_flag(glitter_delivered_flag)
		GlobalState.save_state()
	elif !GlobalState.get_flag(red_paint_delivered_flag) and GlobalState.has_inventory_item(red_paint_item_key):
		red_paint_sprite.show()
		Dialogic.start(red_paint_delivery_timeline)
		GlobalState.remove_intentory_item(red_paint_item_key)
		GlobalState.set_flag(red_paint_delivered_flag)
		GlobalState.save_state()
	else:
		Dialogic.start(no_delivery_timeline)
	
	if GlobalState.get_flag(candle_delivered_flag) and GlobalState.get_flag(glitter_delivered_flag) and GlobalState.get_flag(red_paint_delivered_flag):
		await Dialogic.timeline_ended
		Dialogic.start(final_timeline)