extends Node

signal player_died
const game_over_wait_time := 3.0

func game_over():
	player_died.emit()
	if Dialogic.current_timeline:
		Dialogic.end_timeline(true)

	await get_tree().create_timer(game_over_wait_time).timeout
	get_tree().reload_current_scene()
