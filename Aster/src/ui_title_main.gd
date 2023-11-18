# ui_title_main.gd
class_name UI_TitleMain
extends Control

func _on_button_loadgame_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.loadgame

func _on_button_newgame_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.newgame

func _on_button_options_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.options

func _on_button_mods_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.mods

func _on_button_quit_pressed() -> void:
	Ref.main.quit()
