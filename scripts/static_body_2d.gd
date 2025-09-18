extends Node2D

#@onready var tilemap: TileMapLayer = $TileMapLayer
#@onready var cuerpo: StaticBody2D = $StaticBody2D
#@onready var colision: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	abrir_puerta()

func cerrar_puerta() -> void:
	print("cerrar")
	#tilemap.visible = true   
	#cuerpo.collision_layer = 1 << 7
	#cuerpo.collision_mask = 1 << 7
	#colision.disabled = false

func abrir_puerta() -> void:
	print("abrir")
	#tilemap.visible = false  
	#cuerpo.collision_layer = 0
	#cuerpo.collision_mask = 0
	#colision.disabled = true
