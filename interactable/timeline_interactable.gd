class_name TimelinetInteractable
extends Interactable
## Interactable que inicia uma timeline do Dialogic

@export var timeline_name := ""
@export_group("Pickup")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var pickup := false
@export var pickup_flag: String
@export var pickup_sprite: Node2D

func _ready():
	super ()
	if pickup and GlobalState.get_flag(pickup_flag):
		print("DYING")
		if pickup_sprite:
			pickup_sprite.queue_free()
		queue_free()


func interact():
	Dialogic.start(timeline_name)
	if pickup:
		await Dialogic.timeline_ended
		GlobalState.set_flag(pickup_flag)
		if pickup_sprite:
			pickup_sprite.queue_free()
		queue_free()
