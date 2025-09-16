extends CharacterBody2D

@export var move_speed: float
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var hud = $GUI
@onready var weapon = $Weapon
var is_facing_right = true

var vida_max = 6
var vida_actual = vida_max
var escudo_max = 5
var escudo_actual = escudo_max
var mana_max = 180
var mana_actual = mana_max

# Timers
var shield_regen_delay: Timer
var shield_regen_timer: Timer

#enemigo
var current_target: Node2D = null

func _ready():
	anim_tree.active = true
	hud.set_vida(vida_actual, vida_max)
	hud.set_escudo(escudo_actual, escudo_max)
	hud.set_mana(mana_actual, mana_max)
	
	shield_regen_delay = Timer.new()
	shield_regen_delay.wait_time = 5.0
	shield_regen_delay.one_shot = true
	add_child(shield_regen_delay)
	shield_regen_delay.timeout.connect(_on_shield_regen_delay_timeout)

	shield_regen_timer = Timer.new()
	shield_regen_timer.wait_time = 1.0
	shield_regen_timer.one_shot = false
	add_child(shield_regen_timer)
	shield_regen_timer.timeout.connect(_on_shield_regen_timer_timeout)

func _physics_process(delta):
	move()
	update_animations()
	move_and_slide()

func update_animations():
	# Cambiar entre idle y run
	if velocity.length() > 0:
		anim_state.travel("Run")
	else:
		anim_state.travel("Idle")
	# Actualizar BlendSpace1D para reflejar dirección horizontal
	# Suponiendo que dentro de cada estado ("run" y "idle") tienes un BlendSpace1D llamado "blend_position"
	update_facing()
	pasar_direccion()
	#if velocity.x>0:
		#is_facing_right = true
	#elif velocity.x<0:
		#is_facing_right = false
	var dir = 1 if is_facing_right else -1
	anim_tree.set("parameters/Idle/blend_position", dir)
	anim_tree.set("parameters/Run/blend_position", dir)

func update_facing():
	if current_target:
		is_facing_right = current_target.global_position.x > global_position.x
	else:
		# Control por input del jugador
		if velocity.x > 0:
			is_facing_right = true
		elif velocity.x < 0:
			is_facing_right = false
func move():
	var input_axis = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	

	if input_axis != Vector2.ZERO:
		input_axis = input_axis.normalized()

	velocity = input_axis * move_speed

func _on_hurt_box_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("auchhh")
	apply_damage(1)

func apply_damage(cantidad: int):
	# Siempre que recibo daño, detener regeneración y reiniciar delay
	shield_regen_timer.stop()
	shield_regen_delay.start()

	if escudo_actual > 0:
		escudo_actual -= cantidad
		if escudo_actual < 0:
			# El daño que sobra pasa a la vida
			vida_actual += escudo_actual  # escudo_actual es negativo aquí
			escudo_actual = 0
	else:
		vida_actual -= cantidad
	
	# Clamp valores
	if vida_actual < 0:
		vida_actual = 0
	if escudo_actual < 0:
		escudo_actual = 0

	# Actualizar HUD
	hud.set_vida(vida_actual, vida_max)
	hud.set_escudo(escudo_actual, escudo_max)

# ---- Regeneración del escudo ----
func _on_shield_regen_delay_timeout():
	# Después de 5 seg sin daño → empezar regeneración
	shield_regen_timer.start()

func _on_shield_regen_timer_timeout():
	if escudo_actual < escudo_max:
		escudo_actual += 1
		hud.set_escudo(escudo_actual, escudo_max)
	else:
		shield_regen_timer.stop()
		
func _process(delta):
	# Input: crea la acción "attack" en Project Settings -> Input Map (ver abajo)
	if Input.is_action_just_pressed("basic_attack"):
		weapon.attack(is_facing_right)




#------------calcular enemigo --------------
func _on_enemy_entered(body: Node):
	print("que waso")
	if current_target == null:
		current_target = body
	#if body.is_in_group("enemies"):
		#print("boar in")

func _on_enemy_exited(body: Node):
	print("que wason't")
	if body == current_target:
		current_target = null
		# Buscar si queda otro enemigo en el área
		var bodies = $BuscarEnemigos.get_overlapping_bodies()
		if bodies!=null:
			for b in bodies:
				current_target = b
				break
			#if b.is_in_group("enemies"):

#-------direccion-------------
func pasar_direccion():
	if current_target:
		var dir = (current_target.global_position - global_position).normalized()
		print(dir)
		#weapon.set_direccion(dir)
	else:
		var dir = Vector2.RIGHT if is_facing_right else Vector2.LEFT
		print(dir)
		#weapon.set_direccion(dir)
