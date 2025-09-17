extends Area2D
class_name Gun

@export var bullet_scene: PackedScene  
@onready var muzzle: Marker2D = $Marker2D
var direcction: Vector2 = Vector2.ZERO
var duenio: String = ""

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	monitoring = true   # Para que otros Area2D puedan detectarlo
	
func _process(delta: float) -> void:
	if direcction != Vector2.ZERO:
		rotation = direcction.angle()
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

func set_direccion(dir: Vector2):
	direcction = dir

func attack():
	if not bullet_scene:
		push_error("No bullet scene assigned!")
		return
	
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.asignar_duenio(duenio)
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = muzzle.global_position
	
	var dir = Vector2.RIGHT.rotated(rotation)
	bullet_instance.direction = dir
	bullet_instance.rotation = dir.angle()
	

func set_duenio(d):
	duenio = d
