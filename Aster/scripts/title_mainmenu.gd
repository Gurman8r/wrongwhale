# title_mainmenu.gd
class_name TitleMainmenu
extends Control

func _on_button_loadgame_pressed() -> void:
	Ref.ui.title_interface.current = Ref.ui.title_interface.loadgame

func _on_button_newgame_pressed() -> void:
	Ref.ui.title_interface.current = Ref.ui.title_interface.newgame

func _on_button_options_pressed() -> void:
	Ref.ui.title_interface.current = Ref.ui.title_interface.options

func _on_button_quit_pressed() -> void:
	get_tree().quit()
