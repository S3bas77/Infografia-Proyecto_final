extends Node2D

const BULLET = preload("res://scenes/bullet.tscn")

@onready var muzzle: Marker2D = $Marker2D

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees <270:
		scale.y = -1
	else:
		scale.y = 1
	
	if Input.is_action_just_pressed("basic_attack"):
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
	
		var dir = Vector2.RIGHT.rotated(rotation)
		bullet_instance.direction = dir
		bullet_instance.rotation = dir.angle()   # 🔥 alinear sprite y colisión

		
