# ui_title_loadgame.gd
class_name UI_TitleLoadGame
extends Control

var paths: Array[String]

func _on_button_play_pressed():
	Ref.main.load_file("World_New")

func _on_button_back_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.main

func _refresh() -> void:
	paths.clear()
	var count: int = WorldData.list(paths)
	assert(-1 < count)
	for i in range(0, count):
		pass
