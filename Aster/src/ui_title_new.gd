# ui_title_new.gd
class_name UI_TitleNew
extends Control

const world_default = preload("res://assets/data/world_default.tres")

func _on_button_play_pressed():
	Ref.main.play(world_default.duplicate())

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.main
