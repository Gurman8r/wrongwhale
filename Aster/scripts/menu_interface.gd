# menu_interface.gd
class_name MenuInterface
extends Control

signal menu_changed(value: Menu)

@onready var current: Menu = $MenuMain : set = set_current
@onready var menu_main: MenuMain = $MenuMain
@onready var menu_loadgame: MenuLoadgame = $MenuLoadgame
@onready var menu_newgame: MenuNewgame = $MenuNewgame
@onready var menu_options: MenuOptions = $MenuOptions
@onready var menu_pause: MenuPause = $MenuPause

func set_current(value: Menu) -> void:
	if current == value:
		return
	elif current and not value:
		current.hide()
		current = null
	elif current and value:
		current.hide()
		current = value
		current.show()
	menu_changed.emit(value)

func _on_visibility_changed():
	if not visible and current:
		current = null
