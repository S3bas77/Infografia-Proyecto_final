extends CharacterBody2D

@export var move_speed: float
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var hud = $GUI
var is_facing_right = true

var vida_max = 6
var vida_actual = vida_max
var escudo_max = 5
var escudo_actual = escudo_max
var mana_max = 180
var mana_actual = mana_max

# Timersd
var shield_regen_delay: Timer
var shield_regen_timer: Timer

#enemigo
var current_target: Node2D = null
var enemies_list: Array[Node2D] = []

#objetos
var is_in_range: bool = false
var target_object: Gun = null
var current_weapon: Gun = null
@onready var hand_position: Marker2D = $HandPosition

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

	if current_weapon:
		current_weapon.set_duenio("player")

func _physics_process(delta):
	pickup_object()
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
	if Input.is_action_just_pressed("basic_attack") and current_weapon:
		current_weapon.attack()

#------------calcular enemigo --------------
func _on_enemy_entered(body: Node):
	print("enemigo entró")
	if current_target == null:
		current_target = body
	else:
		enemies_list.append(body)

func _on_enemy_exited(body: Node):
	print("enemigo salió")
	if body == current_target:
		if enemies_list.size() > 0:
			current_target = enemies_list.pop_front()
		else:
			current_target = null
	else:
		enemies_list.erase(body)

#-------direccion-------------
func pasar_direccion():
	if current_target:
		var dir = (current_target.global_position - global_position).normalized()
		#print(dir)
		if current_weapon:
			current_weapon.set_direccion(dir)
	else:
		var dir = Vector2.RIGHT if is_facing_right else Vector2.LEFT
		#print(dir)
		if current_weapon:
			current_weapon.set_direccion(dir)
#---------pasar mask------#

func pickup_object():
	if is_in_range and Input.is_action_just_pressed("pickup") and target_object:
		var picked_weapon = target_object   # guardar referencia local
		target_object = null                # limpiar inmediatamente
		is_in_range = false

		# --- Si ya hay un arma equipada → soltarla ---
		if current_weapon and is_instance_valid(current_weapon):
			var old_weapon = current_weapon
			hand_position.remove_child(old_weapon)
			get_parent().add_child(old_weapon)  # soltar al mismo nivel que el jugador

			# Colocamos el arma cerca del jugador (a la derecha o izquierda)
			var drop_offset = Vector2(20, 0) if is_facing_right else Vector2(-20, 0)
			old_weapon.global_position = global_position + drop_offset

			old_weapon.set_duenio("")  # ya no pertenece al jugador
			print("Arma anterior soltada")

		# --- Equipar el arma recogida ---
		if picked_weapon and is_instance_valid(picked_weapon):
			if picked_weapon.get_parent():
				picked_weapon.get_parent().remove_child(picked_weapon)
			hand_position.add_child(picked_weapon)
			picked_weapon.position = Vector2.ZERO

			# Actualizar referencia
			current_weapon = picked_weapon
			current_weapon.set_duenio("player")

			print("Nueva arma equipada!")


func _on_buscar_objetos_area_exited(area: Area2D) -> void:
	print("Arma fuera de rango")
	if area is Gun:
		is_in_range = false
		target_object = null


func _on_buscar_objetos_area_entered(area: Area2D) -> void:
	print("Arma en rango")
	if area is Gun:
		is_in_range = true
		target_object = area
