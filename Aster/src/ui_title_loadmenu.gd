# ui_title_loadmenu.gd
class_name UI_TitleLoadMenu
extends Control

func _on_button_play_pressed():
	var world_data = WorldData.read("save0")
	if not world_data:
		print("file not found")
		return
	Ref.main.load_game(world_data)

func _on_button_back_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.mainmenu
