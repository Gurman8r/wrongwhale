# ui_title_loadmenu.gd
class_name UI_TitleLoadMenu
extends Control

func _on_button_back_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.mainmenu