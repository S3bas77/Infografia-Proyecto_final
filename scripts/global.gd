# global.gd
extends Node

func _enter_tree():
	# Configurar ventana antes de que se muestre
	var window = get_tree().root
	window.set_size(Vector2i(2712, 1220))
	window.set_mode(Window.MODE_WINDOWED)

func _ready():
	# Cambiar escena después de configurar la ventana
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
