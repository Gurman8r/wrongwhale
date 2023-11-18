# ui_title_loadgame.gd
class_name UI_TitleLoadGame
extends Control

func _on_button_play_pressed():
	Ref.main.load_world_from_file("World_New")

func _on_button_back_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.main

func _refresh() -> void:
	var paths: Array[String] = []
	var count: int = WorldData.list(paths)
	assert(-1 < count)
	for i in range(0, count):
		var path = paths[i]
		print("%s" % [path])
