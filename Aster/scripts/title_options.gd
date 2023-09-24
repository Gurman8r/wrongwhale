# title_options.gd
class_name TitleOptions
extends Control

func _on_button_back_pressed():
	Ref.ui.title_interface.current = Ref.ui.title_interface.main
