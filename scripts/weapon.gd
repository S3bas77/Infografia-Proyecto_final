extends Node2D

@export var damage: int = 1
@export var offset_right := Vector2(12, -4)  
@export var offset_left := Vector2(-12, -4)
@export var hitbox_x_offset := 20          

@onready var sprite: Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Hitbox
@onready var col_shape: CollisionShape2D = $Hitbox/CollisionShape2D

var hit_targets: Array = []   

func _ready():
	area.body_entered.connect(_on_Hitbox_body_entered)
	anim.animation_finished.connect(_on_animation_finished)
	col_shape.disabled = true

func attack(facing_right: bool=true) -> void:
	if anim.is_playing():
		return # no interrumpir animación actual
	
	_set_facing(facing_right)
	hit_targets.clear()
	anim.play("Attack")

func _set_facing(facing_right: bool) -> void:
	if facing_right:
		position = offset_right
		sprite.flip_h = false
		area.position.x = hitbox_x_offset
	else:
		position = offset_left
		sprite.flip_h = true
		area.position.x = -hitbox_x_offset

# Cuando algo entra al hitbox durante ataque
func _on_Hitbox_body_entered(body: Node) -> void:
	if not anim.is_playing():
		return
	if body in hit_targets:
		return
	hit_targets.append(body)

	if body.has_method("take_damage"):
		body.take_damage(damage)
	elif body.has_method("apply_damage"):
		body.apply_damage(damage)
	else:
		print("Weapon hit:", body)

func _on_animation_finished(anim_name: String) -> void:
	hit_targets.clear()
	col_shape.disabled = true
