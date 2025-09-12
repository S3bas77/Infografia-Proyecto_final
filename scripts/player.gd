extends CharacterBody2D

@export var move_speed: float
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
var is_facing_right = true

var vida_max = 6
var vida_actual = vida_max
var escudo_max = 5
var escudo_actual = escudo_max
var mana_max = 180
var mana_actual = mana_max

func _ready():
	anim_tree.active = true

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

#le rebaja vida
func _on_hurt_box_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("auchhh")
	pass # Replace with function body.
