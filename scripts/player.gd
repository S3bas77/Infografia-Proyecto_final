extends CharacterBody2D

@export var move_speed: float
@onready var animated_sprite = $Sprite2D
var is_facing_right = true

func _physics_process(delta):
	move()
	flip()
	update_animations()
	move_and_slide()
	
	
func update_animations():
	if velocity.x or velocity.y:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
func move():
	var input_axis = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	# Normaliza para que en diagonales no sea más rápido
	if input_axis != Vector2.ZERO:
		input_axis = input_axis.normalized()
	
	velocity = input_axis * move_speed

func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right
