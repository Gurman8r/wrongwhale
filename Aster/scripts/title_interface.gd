# title_interface.gd
class_name TitleInterface
extends Control

signal menu_changed(value: Control)

@onready var current: Control = $TitleMain : set = set_current
@onready var main: TitleMain = $TitleMain
@onready var loadgame: TitleLoadgame = $TitleLoadgame
@onready var newgame: TitleNewgame = $TitleNewgame
@onready var options: TitleOptions = $TitleOptions

func set_current(value: Control):
	Ref.ui.transition.play_fadeout()
	await Ref.ui.transition.finished
	if current: current.hide()
	current = value
	if current: current.show()
	Ref.ui.transition.play_fadein()
	await Ref.ui.transition.finished
