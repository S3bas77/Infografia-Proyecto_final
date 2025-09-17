extends TextureButton

@onready var timer = $Timer
@onready var label = $Label

func _ready():
	timer.wait_time = 1.5
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	# SOLO UNA conexión pressed
	pressed.connect(_on_pressed)
	
	# Señales de hover
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_timer_timeout():
	if label:
		label.visible = !label.visible
	else:
		modulate.a = 0.0 if modulate.a > 0.5 else 1.0

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func _on_pressed():
	print("Intentando cargar: res://scenes/main.tscn")
	
	# Verificar si el archivo existe
	if FileAccess.file_exists("res://scenes/main.tscn"):
		print("El archivo existe - cambiando escena...")
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		print("ERROR: No se encuentra res://main.tscn")
		# Buscar archivos .tscn en el proyecto
		var files = []
		var dir = DirAccess.open("res://")
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.ends_with(".tscn"):
					files.append(file_name)
				file_name = dir.get_next()
			print("Escenas disponibles: ", files)
