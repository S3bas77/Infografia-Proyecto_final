extends CanvasLayer

@onready var vida_bar = $Marco_barras/Vida_bar
@onready var vida_label = $Marco_barras/Vida_bar/Vida_label
@onready var escudo_bar = $Marco_barras/Escudo_bar
@onready var escudo_label = $Marco_barras/Escudo_bar/Escudo_label
@onready var mana_bar = $Marco_barras/Marra_bar
@onready var mana_label = $Marco_barras/Marra_bar/Marra_label

func set_vida(actual: int, maximo: int):
	vida_bar.max_value = maximo
	vida_bar.value = actual
	vida_label.text = str(actual, "/", maximo)

func set_escudo(actual: int, maximo: int):
	escudo_bar.max_value = maximo
	escudo_bar.value = actual
	escudo_label.text = str(actual, "/", maximo)

func set_mana(actual: int, maximo: int):
	mana_bar.max_value = maximo
	mana_bar.value = actual
	mana_label.text = str(actual, "/", maximo)
