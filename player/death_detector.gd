extends Area2D

const DEATH_GROUP := "death"


func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D):
	if area.is_in_group(DEATH_GROUP):
		GameManager.game_over(area.name)