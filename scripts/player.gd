#extends CharacterBody2D
#
#@export var move_speed: float
#@onready var animated_sprite = $Sprite2D
#var is_facing_right = true
#
#func _physics_process(delta):
	#move()
	#flip()
	#update_animations()
	#move_and_slide()
	#
	#
#func update_animations():
	#if velocity.x or velocity.y:
		#animated_sprite.play("run")
	#else:
		#animated_sprite.play("idle")
	#
#func move():
	#var input_axis = Vector2(
		#Input.get_axis("move_left", "move_right"),
		#Input.get_axis("move_up", "move_down")
	#)
	#
	## Normaliza para que en diagonales no sea más rápido
	#if input_axis != Vector2.ZERO:
		#input_axis = input_axis.normalized()
	#
	#velocity = input_axis * move_speed
#
#func flip():
	#if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		#scale.x *= -1
		#is_facing_right = not is_facing_right


extends CharacterBody2D

@export var move_speed: float
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
var is_facing_right = true

func _ready():
	anim_tree.active = true

func _physics_process(delta):
	move()
	#flip()
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
	if velocity.x>0:
		is_facing_right = true
	elif velocity.x<0:
		is_facing_right = false
	var dir = 1 if is_facing_right else -1
	
	anim_tree.set("parameters/Idle/blend_position", dir)
		
	anim_tree.set("parameters/Run/blend_position", dir)

func move():
	var input_axis = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if input_axis != Vector2.ZERO:
		input_axis = input_axis.normalized()

	velocity = input_axis * move_speed

#func flip():
	## Solo flip horizontal
	#if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		#scale.x *= -1
		#is_facing_right = not is_facing_right
