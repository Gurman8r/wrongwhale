# ui_title_options.gd
class_name UI_TitleOptions
extends Control

func _on_button_back_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.main
