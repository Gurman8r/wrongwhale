# ui_title.gd
class_name UI_Title
extends Control

signal menu_changed(value: Control)

@onready var current: Control = $Mainmenu : set = set_current
@onready var mainmenu: UI_TitleMainmenu = $Mainmenu
@onready var loadgame: UI_TitleLoadgame = $Loadgame
@onready var newgame: UI_TitleNewgame = $Newgame
@onready var options: UI_TitleOptions = $Options

func set_current(value: Control):
	Ref.ui.transition.fadeout()
	await Ref.ui.transition.finished
	
	if current: current.hide()
	current = value
	if current: current.show()
	
	Ref.ui.transition.fadein()
	await Ref.ui.transition.finished
