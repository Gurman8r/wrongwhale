# title_interface.gd
class_name TitleInterface
extends Control

signal menu_changed(value: Control)

@onready var current: TitleMenu = $TitleMain
@onready var main: TitleMain = $TitleMain
@onready var loadgame: TitleLoadgame = $TitleLoadgame
@onready var newgame: TitleNewgame = $TitleNewgame
@onready var options: TitleOptions = $TitleOptions

func _on_visibility_changed():
	if not visible and current:
		current.hide()
