# ui_title.gd
class_name UI_Title
extends Control

signal menu_changed(value: Control)

@onready var current: Control = $MainMenu : set = set_current
@onready var mainmenu: UI_TitleMainMenu = $MainMenu
@onready var loadmenu: UI_TitleLoadMenu = $LoadMenu
@onready var newmenu: UI_TitleNewMenu = $NewMenu
@onready var optionmenu: UI_TitleOptionMenu = $OptionMenu

func set_current(value: Control):
	Ref.ui.transition.fadeout()
	await Ref.ui.transition.finished
	
	if current: current.hide()
	current = value
	if current: current.show()
	
	Ref.ui.transition.fadein()
	await Ref.ui.transition.finished
