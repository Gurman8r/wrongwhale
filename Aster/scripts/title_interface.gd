# title_interface.gd
class_name TitleInterface
extends Control

signal menu_changed(value: Control)

@onready var current: TitleBase = $TitleMain : set = set_current
@onready var main: TitleMain = $TitleMain
@onready var loadgame: TitleLoadgame = $TitleLoadgame
@onready var newgame: TitleNewgame = $TitleNewgame
@onready var options: TitleOptions = $TitleOptions

func _on_visibility_changed():
	if not visible and current:
		current.hide()

func set_current(value: TitleBase):
	Ref.ui.transition.play_fadeout()
	await Ref.ui.transition.finished
	if current: current.hide()
	current = value
	if current: current.show()
	Ref.ui.transition.play_fadein()
	await Ref.ui.transition.finished
