# ui_title_optionmenu.gd
class_name UI_TitleOptionMenu
extends Control

func _on_button_back_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.mainmenu
