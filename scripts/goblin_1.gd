extends CharacterBody2D

@export var move_speed: float = 100.0
@export var vida_max: int = 6
@export var escudo_max: int = 5

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

var vida_actual: int
var escudo_actual: int
var is_facing_right: bool = true
var current_target: Node2D = null

var attack_timer: Timer
func _ready():
	vida_actual = vida_max
	escudo_actual = escudo_max

	anim_tree.active = true

	# Timer para ataques automáticos
	attack_timer = Timer.new()
	attack_timer.wait_time = 0.5
	attack_timer.autostart = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)
	$Gun.set_duenio("enemigo")



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
	if velocity.length() > 0:
		anim_state.travel("Run")
	else:
		anim_state.travel("Idle")

	update_facing()
	var dir = 1 if is_facing_right else -1
	anim_tree.set("parameters/Idle/blend_position", dir)
	anim_tree.set("parameters/Run/blend_position", dir)


func update_facing() -> void:
	if current_target:
		is_facing_right = current_target.global_position.x > global_position.x
	else:
		if velocity.x > 0:
			is_facing_right = true
		elif velocity.x < 0:
			is_facing_right = false


# ---------------- ATAQUE ----------------
func _on_attack_timer_timeout() -> void:
	if current_target:
		var dir = (current_target.global_position - global_position).normalized()
		$Gun.set_direccion(dir)
		$Gun.attack()


# ---------------- DAÑO ----------------
func take_damage(cantidad: int) -> void:
	if escudo_actual > 0:
		escudo_actual -= cantidad
		if escudo_actual < 0:
			vida_actual += escudo_actual 
			escudo_actual = 0
	else:
		vida_actual -= cantidad

	vida_actual = max(vida_actual, 0)
	escudo_actual = max(escudo_actual, 0)

	if vida_actual == 0:
		die()


func die() -> void:
	queue_free()

#-------------encontrar al player ---------#
func _on_buscar_player_body_entered(body: Node2D) -> void:
	if current_target == null:
		current_target = body


func _on_buscar_player_body_exited(body: Node2D) -> void:
	if body == current_target:
		current_target = null


#------------------set player--------------"
func set_player(player:CharacterBody2D):
	current_target = player
