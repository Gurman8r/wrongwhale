# title_interface.gd
class_name TitleInterface
extends Control

signal menu_changed(value: Control)

@onready var current: Control = $TitleMainmenu : set = set_current
@onready var mainmenu: TitleMainmenu = $TitleMainmenu
@onready var loadgame: TitleLoadgame = $TitleLoadgame
@onready var newgame: TitleNewgame = $TitleNewgame
@onready var options: TitleOptions = $TitleOptions

func set_current(value: Control) -> void:
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
