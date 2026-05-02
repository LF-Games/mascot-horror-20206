class_name Battery
extends Node

@export var point_light: PointLight2D
@export var duration_modifier1 := 6
@export var duration_modifier2 := 4
@export var duration_modifier3 := 3
@export var light_fade_duration := 1

var max_battery_count := 3 # bateria máxima
var current_level := 2
var current_level_duration := 100.0
@export var light_scale_lv2 := 1.0
@export var light_scale_lv1 := 0.75
@export var light_scale_lv0 := 0.5
var tween: Tween


func _ready():
	point_light.texture_scale = light_scale_lv2
	GameManager.player_died.connect(_on_game_over)


func _process(delta: float) -> void:
	#check de qual bateria está funcionando / timer da bateria
	if current_level == 2:
		current_level_duration -= delta * duration_modifier1 # valores modificáveis pra velocidades diferentes
	elif current_level == 1:
		current_level_duration -= delta * duration_modifier2
	else:
		current_level_duration -= delta * duration_modifier3
	
	if current_level_duration < 0:
		set_current_level(current_level - 1)


func set_current_level(value: int):
	current_level = value
		
	if current_level < 0: # checa se a luz acabou
		GameManager.game_over()
		
	current_level_duration = 100.0 # reinicia o timer
	if current_level == 2:
		if tween:
			tween.kill() # check pra garantir que não tem tweens ativos
	
		tween = get_tree().create_tween() # criando tree do tween
		tween.tween_property(point_light, "texture_scale", light_scale_lv2, light_fade_duration) # tween da luz nivel 2

	if current_level == 1:
		if tween:
			tween.kill() # check pra garantir que não tem tweens ativos
	
		tween = get_tree().create_tween() # criando tree do tween
		tween.tween_property(point_light, "texture_scale", light_scale_lv1, light_fade_duration) # tween da luz nivel 1

	if current_level == 0:
		if tween:
			tween.kill() # check pra garantir que não tem tweens ativos
	
		tween = get_tree().create_tween() # criando tree do tween
		tween.tween_property(point_light, "texture_scale", light_scale_lv0, light_fade_duration) # tween da luz nivel 0


func is_low_battery():
	return current_level == 0


func _on_game_over():
	set_process(false)
	if tween:
			tween.kill()
	tween = get_tree().create_tween() # criando tree do tween
	tween.tween_property(point_light, "texture_scale", 0, light_fade_duration) # tween da luz nivel 0
