extends "res://scripts/enemy_1.gd"

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_state = null

var is_facing_right: bool = true

func _ready():
	super._ready()  
	anim_tree.active = true
	anim_state = anim_tree.get("parameters/playback")
#
func _physics_process(delta):
	super._physics_process(delta)  
	update_animations()            

func update_animations():
	#print("velocity:", velocity)
	if velocity.length() > 0.1:
		anim_state.travel("Run")
	else:
		anim_state.travel("Idle")

	if velocity.x > 0:
		is_facing_right = true
	elif velocity.x < 0:
		is_facing_right = false

	var dir = 1 if is_facing_right else -1
	anim_tree.set("parameters/Idle/blend_position", dir)
	anim_tree.set("parameters/Run/blend_position", dir)
