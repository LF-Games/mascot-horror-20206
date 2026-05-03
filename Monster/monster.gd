extends CharacterBody2D

enum State {IDLE, CHASE}

@export var speed: float = 100.0 # speed monstro
@export var detection_range: float = 400.0 # IDLE -> CHASE Quando player entra no range o estado muda
@export var lose_range: float = 450.0 # CHASE -> IDLE Quando player sai do range o monstro perde o target
@export var target: CharacterBody2D
@export var silhouetteavo: AnimatedSprite2D
@export var idle_speed: float = 60.0 # speed no modo idle/wander
@export var wander_range: float = 250.0 # range do Raio circular do wander(vagar)

@onready var animation = $AnimatedSprite2D
@onready var navegant: NavigationAgent2D = $NavigationAgent2D

var current_state: State = State.IDLE
var _wander_timer: float = 0.0
var _nav_ready: bool = false

# ── READY ────────────────────────────────────────────────
func _ready() -> void:
	animation.play("Avo_monstro")
	navegant.path_desired_distance = 4.0
	navegant.target_desired_distance = 16.0
	
	NavigationServer2D.map_changed.connect(_on_map_ready)

func _on_map_ready(_map_rid: RID) -> void:
	#desconecta para não chamar mais de uma vez
	NavigationServer2D.map_changed.disconnect(_on_map_ready)
	_nav_ready = true
	_pick_wander_target()


func _physics_process(_delta):
	if target == null:
		return
	var distance = global_position.distance_to(target.global_position)

	match current_state:
		State.IDLE: _state_idle(_delta, distance)
		State.CHASE: _state_chase(distance)

# ── IDLE ────────────────────────────────────────────────
func _state_idle(delta: float, distance: float) -> void:
	if not _nav_ready:
		return
	if distance < detection_range:
		current_state = State.CHASE
		return

	_wander_timer -= delta
	if _wander_timer <= 0.0 or navegant.is_navigation_finished():
		_pick_wander_target()

	if not navegant.is_navigation_finished():
		var next_pos = navegant.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * idle_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()


# ── CHASE ────────────────────────────────────────────────
func _state_chase(distance: float) -> void:
	if distance > lose_range:
		current_state = State.IDLE
		_pick_wander_target()
		return
		
	if navegant.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
			# Move em direção ao próximo ponto do caminho
	var next_pos = navegant.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	## inverter sprite
	if direction.x < 0:
		animation.flip_h = true
		silhouetteavo.flip_h = true
	else:
		animation.flip_h = false
		silhouetteavo.flip_h = false
	move_and_slide()

# ── WANDER — sorteia ponto dentro dos polígonos navegáveis ──
func _pick_wander_target() -> void:
	if not _nav_ready:
		return
	var map = navegant.get_navigation_map()
	var point_found = false

	for attempt in range(15):
		# Sorteia ângulo em qualquer direção igualmente
		var angle = randf() * TAU
		var distance = randf_range(50.0, wander_range)
		
		var random_point = global_position + Vector2(
			cos(angle) * distance,
			sin(angle) * distance
			)
		
		var closest = NavigationServer2D.map_get_closest_point(map, random_point)
		
		if random_point.distance_to(closest) < 32.0:
			navegant.target_position = closest
			point_found = true
			break
			
	if not point_found:
		navegant.target_position = global_position
		
	_wander_timer = randf_range(2.0, 5.0)
	
	
# ── TIMER ────────────────────────────────────────────────
func _update_target_position() -> void:
	if target != null and current_state == State.CHASE:
		navegant.target_position = target.global_position


func _on_timer_timeout() -> void:
	_update_target_position()
