extends Node2D

@onready var area_trigger = $Area2D
@onready var spawn_points = $EnemiesSpawn.get_children()
@onready var doors = $Doors
var player: CharacterBody2D = null
var enemy_scene = preload("res://scenes/boar.tscn")
var enemies_alive: int = 0
var current_round: int = 0
var max_rounds: int = 3
var enemies_per_round: int = 3
#func _ready() -> void:
	#area_trigger.body_entered.connect(_on_body_entered)

func start_round() -> void:
	if current_round < max_rounds:
		current_round += 1
		print("Iniciando ronda ", current_round)
		spawn_enemies(enemies_per_round)
	else:
		print("Ya se completaron todas las rondas")
		#open_doors()

func _on_body_entered(body: Node) -> void:
	print("suerteeee")
	player = body
	start_round()

func spawn_enemies(amount: int) -> void:
	var collision_shape = area_trigger.get_node("CollisionShape2D")
	if collision_shape.shape is RectangleShape2D:
		var rect_size = collision_shape.shape.extents
		var rect_center = collision_shape.global_position
		if player == null:
			push_error("⚠ No encontré al Player en el grupo 'Player'")
			return
		for i in range(amount):
			var enemy = enemy_scene.instantiate()
			enemy.target = player
			get_parent().add_child(enemy)
			var rand_x = randf_range(-rect_size.x, rect_size.x)
			var rand_y = randf_range(-rect_size.y, rect_size.y)
			enemy.global_position = rect_center + Vector2(rand_x, rand_y)
			enemies_alive += 1
			enemy.tree_exited.connect(_on_enemy_dead)

func _on_enemy_dead() -> void:
	enemies_alive -= 1
	if enemies_alive <= 0:
		start_round()

func close_doors() -> void:
	for door in doors.get_children():
		door.visible = true
		if door.has_node("CollisionShape2D"):
			door.get_node("CollisionShape2D").disabled = false

func open_doors() -> void:
	for door in doors.get_children():
		door.visible = false
		if door.has_node("CollisionShape2D"):
			door.get_node("CollisionShape2D").disabled = true
