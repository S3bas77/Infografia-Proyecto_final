extends CanvasLayer

@onready var vida_bar = $TextureRect/VidaBar
@onready var vida_label = $TextureRect/VidaBar/VidaLabel
@onready var escudo_bar = $TextureRect/EscudoBar
@onready var escudo_label = $TextureRect/EscudoBar/EscudoLabel
@onready var mana_bar = $TextureRect/ManaBar
@onready var mana_label = $TextureRect/ManaBar/ManaLabel

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
