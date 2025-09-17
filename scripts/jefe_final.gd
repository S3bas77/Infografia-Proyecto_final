extends CharacterBody2D

@export var move_speed: float = 100.0
@export var vida_max: int = 6
@export var escudo_max: int = 5
@export var bullet_scene: PackedScene
@export var attack_cooldown: float = 3.0
@export var radial_bullets: int = 12
@export var directed_bullets: int = 5
@export var bullet_speed: float = 300.0
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

var current_target: Node2D
var attack_timer: Timer
var attack_index: int = 0 

var vida_actual: int
var escudo_actual: int
var is_facing_right: bool = true
func _ready() -> void:

	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.autostart = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func _physics_process(delta: float) -> void:
	move()
	update_animations()
	move_and_slide()


# ---------------- MOVIMIENTO ----------------
func move() -> void:
	if current_target:
		var desired_distance = 75.0  # Distancia que quieres mantener
		var to_target = current_target.global_position - global_position
		var distance = to_target.length()
		if distance < desired_distance:
			var dir = -to_target.normalized() 
			velocity = dir * move_speed
		elif distance > desired_distance:
			var dir = to_target.normalized()  
			velocity = dir * move_speed
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO


# ---------------- ANIMACIONES ----------------
func update_animations() -> void:
	anim_state.travel("Run")
	
	update_facing()
	var dir = 1 if is_facing_right else -1
	anim_tree.set("parameters/Idle/blend_position", dir)


func update_facing() -> void:
	if current_target:
		is_facing_right = current_target.global_position.x > global_position.x
	else:
		if velocity.x > 0:
			is_facing_right = true
		elif velocity.x < 0:
			is_facing_right = false

# Alternar ataques
func _on_attack_timer_timeout() -> void:
	if attack_index == 0:
		shoot_radial()
		attack_index = 1
	else:
		shoot_directed()
		attack_index = 0


# ------------------ ATAQUES ------------------

# Dispara balas en todas direcciones
func shoot_radial() -> void:
	for i in range(radial_bullets):
		var angle = (TAU / radial_bullets) * i
		var dir = Vector2.RIGHT.rotated(angle)
		spawn_bullet(dir)

# Dispara varias balas hacia el Player
func shoot_directed() -> void:
	if not current_target:
		return
	var dir_to_player = (current_target.global_position - global_position).normalized()
	for i in range(directed_bullets):
		spawn_bullet(dir_to_player)


# ------------------ CREAR BULLET ------------------
func spawn_bullet(dir: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = dir
	bullet.speed = bullet_speed
	bullet.asignar_duenio("enemigo")
	get_parent().add_child(bullet)


func _on_encontrar_player_body_entered(body: Node2D) -> void:
	if current_target == null:
		current_target = body
