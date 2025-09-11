extends CharacterBody2D
#class_name Navigation
@export var target: Node2D = null
@export var max_speed = 50

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func setup():
	# espera al primer frame de fisicas
	await get_tree().physics_frame
	if target:
		nav.target_position = target.global_position

func _ready() -> void:
	call_deferred("setup")
	print(nav.get_current_navigation_path())
	
func _physics_process(delta: float) -> void:
	if target:
		nav.target_position = target.global_position
	if nav.is_navigation_finished():
		return
	var next_path_position = nav.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * max_speed
	move_and_slide()
