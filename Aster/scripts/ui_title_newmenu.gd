# ui_title_newmenu.gd
class_name UI_TitleNewMenu
extends Control

@export var world_data: WorldData

func _on_button_play_pressed():
	Ref.main.load_world(world_data)

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
