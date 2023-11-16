# ui_title_newmenu.gd
class_name UI_TitleNewMenu
extends Control

const world_default = preload("res://assets/data/world_default.tres")

@onready var world_data: WorldData = world_default.duplicate()

func _on_button_play_pressed():
	Ref.main.load_game(world_data)

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
