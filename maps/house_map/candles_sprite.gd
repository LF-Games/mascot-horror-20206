extends Sprite2D

const PICKUP_FLAG := "CANDLES_GET"


func _ready():
	GlobalState.flag_raised.connect(_on_flag_raised)
	if GlobalState.get_flag(PICKUP_FLAG):
		queue_free()
	

func _on_flag_raised(flag: String):
	if flag == PICKUP_FLAG:
		queue_free()
