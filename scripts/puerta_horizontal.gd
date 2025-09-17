extends Node2D

@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var cuerpo: StaticBody2D = $StaticBody2D
@onready var colision: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	abrir()

func cerrar() -> void:
	tilemap.visible = true   
	cuerpo.collision_layer = 1 << 7
	cuerpo.collision_mask = 1 << 7
	colision.disabled = false

func abrir() -> void:
	tilemap.visible = false  
	cuerpo.collision_layer = 0
	cuerpo.collision_mask = 0
	colision.disabled = true
