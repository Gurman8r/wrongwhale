# menu_interface.gd
class_name MenuInterface
extends Control

signal menu_changed(menu: Control)

@onready var menu: Control = $MenuMain
@onready var menu_main: MenuMain = $MenuMain
@onready var menu_loadgame: MenuLoadgame = $MenuLoadgame
@onready var menu_newgame: MenuNewgame = $MenuNewgame
@onready var menu_options: MenuOptions = $MenuOptions

func _ready():
	assert(menu)
	assert(menu_main)
	assert(menu_loadgame)
	assert(menu_newgame)
	assert(menu_options)

func show_menu(value: Control) -> void:
	if menu == value:
		return
	elif menu and not value:
		menu.hide()
		menu = null
	elif menu and value:
		menu.hide()
		menu = value
		menu.show()
	menu_changed.emit(menu)
