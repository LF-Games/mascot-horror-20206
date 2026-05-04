extends Node

@export var wolf_monster: Monster
@export var grandma_monster: Monster
@export var wolf_anim: AnimationPlayer
@export var grandma_anim: AnimationPlayer
@export var cooldown: Timer


func _ready():
	wolf_monster.player_detected.connect(_on_monster_alert.bind(wolf_anim))
	grandma_monster.player_detected.connect(_on_monster_alert.bind(grandma_anim))
	GameManager.player_died.connect(_on_game_over)


func _on_monster_alert(anim: AnimationPlayer):
	if cooldown.time_left <= 0:
		anim.play("alert")
		cooldown.start()


func _on_game_over(cause):
	if cause == "Wolf":
		wolf_anim.play("game_over")
	elif cause == "Grandma":
		grandma_anim.play("game_over")
