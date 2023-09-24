# title_loadgame.gd
class_name TitleLoadgame
extends Control

func _on_button_back_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.main
