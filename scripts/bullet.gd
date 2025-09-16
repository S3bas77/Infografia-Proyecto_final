extends Area2D

@export var speed: float = 300
@export var damage: int = 1
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var lifetime_timer: Timer

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	# Crear el Timer por código
	lifetime_timer = Timer.new()
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	add_child(lifetime_timer)
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	lifetime_timer.start()

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_damage"):
		body.apply_damage(damage)
		print("hola")
	elif body.has_method("take_damage"):
		body.take_damage(damage)
		

	queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
