extends Node2D

@export var damage: int = 1
@export var offset_right := Vector2(12, -4)  # ajustar según tu sprite
@export var offset_left := Vector2(-12, -4)
@export var hitbox_x_offset := 20             # separación hitbox cuando está a la derecha

@onready var sprite: Sprite2D = $Sprite
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Hitbox
@onready var col_shape: CollisionShape2D = $Hitbox/CollisionShape2D

var hit_targets: Array = []    # lista para evitar multihits en el mismo ataque

func _ready():
	# Conectar señales
	area.body_entered.connect(_on_Hitbox_body_entered)
	anim.animation_finished.connect(_on_animation_finished)
	# Asegurarnos que el hitbox esté desactivado por defecto
	col_shape.disabled = true

# Llamar desde Player: weapon.attack(is_facing_right)
func attack(facing_right: bool=true) -> void:
	if anim.is_playing():
		return # no interrumpir animación actual
	
	_set_facing(facing_right)
	hit_targets.clear()
	anim.play("Attack")

# Ajusta la posición/flip del arma según la dirección del jugador
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
	# Solo si la anim está reproduciéndose, para evitar golpes fuera de ataque
	if not anim.is_playing():
		return
	# Evitar dañar el mismo cuerpo varias veces en el mismo ataque
	if body in hit_targets:
		return
	hit_targets.append(body)

	# Llama al método que tenga tu enemigo; ajusta el nombre según tu implementación
	if body.has_method("take_damage"):
		body.take_damage(damage)
	elif body.has_method("apply_damage"):
		body.apply_damage(damage)
	else:
		# fallback: imprime para depurar
		print("Weapon hit:", body)

# Al terminar la animación limpiamos
func _on_animation_finished(anim_name: String) -> void:
	hit_targets.clear()
	# asegurar hitbox desactivado (por si)
	col_shape.disabled = true
