extends Node

signal player_died(cause: String)
const game_over_wait_time := 3.0

func game_over(cause := ""):
	player_died.emit(cause)
	if Dialogic.current_timeline:
		Dialogic.end_timeline(true)

	await get_tree().create_timer(game_over_wait_time).timeout
	GlobalState.load_state()
	get_tree().reload_current_scene()
