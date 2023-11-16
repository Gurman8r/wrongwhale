# ui_title_load.gd
class_name UI_TitleLoad
extends Control

func _on_button_play_pressed():
	var world_data: WorldData = WorldData.read("save0")
	if not world_data: return
	Ref.main.play(world_data)

func _on_button_back_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.main
