extends Area2D

@onready var tilemap: TileMapLayer = get_parent().get_node("TileMapLayer")
var bloqueo_body: StaticBody2D = null

func cerrar_puerta() -> void:
	tilemap.visible = true

	if bloqueo_body == null:
		# Crear StaticBody2D temporal
		bloqueo_body = StaticBody2D.new()
		bloqueo_body.collision_layer = (1 << 0) | (1 << 7)  # Layers 1 y 8
		bloqueo_body.collision_mask  = (1 << 0) | (1 << 7)  # Colisiona con 1 y 8
		
		# Crear CollisionShape2D
		var shape = CollisionShape2D.new()
		shape.shape = RectangleShape2D.new()
		shape.shape.extents = get_node("CollisionShape2D").shape.extents
		bloqueo_body.add_child(shape)
		
		add_child(bloqueo_body)

func abrir_puerta() -> void:
	tilemap.visible = false
	if bloqueo_body:
		bloqueo_body.queue_free()
		bloqueo_body = null
