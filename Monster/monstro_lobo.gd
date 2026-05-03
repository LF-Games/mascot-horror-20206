extends CharacterBody2D

enum State {IDLE, CHASE}

@export var speed: float = 100.0 # speed monstro
@export var detection_range: float = 400.0 # IDLE -> CHASE Quando player entra no range o estado muda
@export var lose_range: float = 450.0 # CHASE -> IDLE Quando player sai do range o monstro perde o target
@export var target: CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var silhouetteavo = $AnimatedSprite2D/SilhouetteWolf
@onready var navegant: NavigationAgent2D = $NavigationAgent2D

var current_state: State = State.IDLE

func _physics_process(_delta):
	if target == null:
		return
	var distance = global_position.distance_to(target.global_position)
	
	match current_state:
		State.IDLE:
			_state_idle(distance)
		State.CHASE:
			_state_chase(distance)
			
# ── IDLE ────────────────────────────────────────────────
func _state_idle(distance: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	
	if distance < detection_range:
		current_state = State.CHASE

# ── CHASE ────────────────────────────────────────────────
func _state_chase(distance: float) -> void:
	if distance > lose_range:
		current_state = State.IDLE
		return
		
			# Move em direção ao próximo ponto do caminho
	var next_pos = navegant.get_next_path_position()
	var direction = to_local(next_pos).normalized()
	#var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
		## inverter sprite
	if direction.x < 0:
		animation.flip_h = true
		silhouetteavo.flip_h = true
	else:
		animation.flip_h = false
		silhouetteavo.flip_h = false
	
func _update_target_position() -> void:
	if target != null and current_state == State.CHASE:
		navegant.target_position = target.global_position

func _ready() -> void:
	animation.play("Lobo_monstro")
	silhouetteavo.play("Lobo_monstro")
	await get_tree().physics_frame

func _on_timer_timeout() -> void:
	_update_target_position()
