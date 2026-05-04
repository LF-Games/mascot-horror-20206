class_name Player
extends CharacterBody2D
## Classe responsável pela movimentação e ações do jogador

@export var _speed := 300
@export var battery: Battery
@export var recharge_bar: ProgressBar
@export var recharge_audio: AudioStreamPlayer
@export var sound_player: AnimationPlayer
@export var battery_text_animation: AnimationPlayer
@export var recharge_duration := 2.0
@export var death_fade_duration := 0.3

var _flipped := false
var _can_move := true
var _can_interact := true
var time_pressed := 0.0
var recharge_completed := false
@export var _sprite: AnimatedSprite2D
@export var _silhouette_sprite: AnimatedSprite2D
@onready var _interaction_detector := $InteractionDetector as InteractionDetector


func _ready():
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	GameManager.player_died.connect(_on_game_over)


func _physics_process(_delta):
	if !_can_move:
		return
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * _speed

	if direction.x < 0 and !_flipped:
		_sprite.transform.x *= -1
		_flipped = true
	elif direction.x > 0 and _flipped:
		_sprite.transform.x *= -1
		_flipped = false
	
	if direction.length_squared() == 0:
		_silhouette_sprite.play("idle")
		_sprite.play("idle")
		sound_player.pause()

	else:
		_silhouette_sprite.play("walk")
		_sprite.play("walk")
		sound_player.play("footstep_loop")

	move_and_slide()


func _process(_delta):
	if Input.is_action_just_pressed("interact") and _can_interact:
		_interaction_detector.try_interaction()
	
	if Input.is_action_pressed("recharge_battery") and !recharge_completed:
		if GlobalState.has_inventory_item("BATTERY"):
			if !recharge_audio.playing:
				recharge_audio.play()
				_sprite.stop() ## Pausa o player sprite quando estiver recarregando
				_sprite.play("idle")
				_sprite.frame = 0
				_sprite.pause()
				_silhouette_sprite.stop() ## Pausa a silhueta do player quando estiver recarregando
				_silhouette_sprite.play("idle")
				_silhouette_sprite.frame = 0
				_silhouette_sprite.pause()
				sound_player.pause()
		
			_can_move = false
			_can_interact = false
			recharge_bar.visible = true # pode ser colocado no control depois
		
			recharge_bar.value = time_pressed # pode ser colocado no control depois
			time_pressed += _delta
		
			if time_pressed > recharge_duration:
				battery.set_current_level(2)
				time_pressed = 0
				recharge_completed = true
				GlobalState.remove_intentory_item("BATTERY")
		
		else:
			battery_text_animation.play("no battery text pop up")
	else:
		time_pressed = 0
		recharge_bar.visible = false # pode ser colocado no control depois
		
		_can_move = true
		_can_interact = true
	
	if Input.is_action_just_released("recharge_battery"):
		recharge_completed = false
		recharge_audio.stop()


func _on_timeline_started():
	_can_move = false
	_can_interact = false
	_silhouette_sprite.play("idle")
	_sprite.play("idle")
	sound_player.pause()
	set_process(false)


func _on_timeline_ended():
	await get_tree().process_frame
	_can_move = true
	_can_interact = true
	set_process(true)


func _on_game_over(_cause):
	set_process(false)
	set_physics_process(false)
	_sprite.play("idle")
	_silhouette_sprite.play("idle")
	sound_player.pause()
	var tween = create_tween()
	tween.tween_property(_sprite, "modulate", Color.TRANSPARENT, death_fade_duration)
