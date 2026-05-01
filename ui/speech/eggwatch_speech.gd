class_name EggwatchSpeech
extends RichTextLabel
## Classe que exibe falas do mascote periodicamente durante a gameplay

@export var speech_lines: Array[String]
@export var min_cooldown := 5.0
@export var max_cooldown := 12.0
@export var reveal_speed := 1.0
@export var linger_duration := 1.0
@export var audio_stream: AudioStream

var _current_cooldown
var _speaking := false
var _tracked_characters := 0


func _ready():
	_current_cooldown = min_cooldown
	hide()
	visible_characters = 0


func _process(delta):
	if _speaking:
		if visible_ratio < 1:
			visible_ratio += reveal_speed * delta
		else:
			_speaking = false
			await get_tree().create_timer(linger_duration).timeout
			hide()
		if _tracked_characters != visible_characters:
			_tracked_characters = visible_characters
			var last_revealed := text[_tracked_characters - 1]
			
			if last_revealed.strip_edges() != "":
				var stream_player := AudioStreamPlayer.new()
				add_child(stream_player)
				stream_player.stream = audio_stream
				stream_player.play()
				stream_player.pitch_scale = [1.0, 1.0, 1.0, 1.0, 1.0, 1.1].pick_random()
				await stream_player.finished
				stream_player.queue_free()
		return

	
	_current_cooldown -= delta
	if _current_cooldown <= 0:
		_reset_cooldown()
		_speak()


func _reset_cooldown():
	_current_cooldown = randf_range(min_cooldown, max_cooldown)


func _speak():
	show()
	text = "[shake rate=20.0 level=5 connected=1]%s[/shake]" % speech_lines.pick_random().to_upper()
	visible_characters = 0
	_tracked_characters = 0
	_speaking = true
