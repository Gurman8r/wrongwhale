# ui_title_options.gd
class_name UI_TitleOptions
extends Control

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
