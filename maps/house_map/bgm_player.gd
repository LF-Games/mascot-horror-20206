extends AudioStreamPlayer

func _ready():
	GameManager.player_died.connect(func(_cause):
		stop()
	)
