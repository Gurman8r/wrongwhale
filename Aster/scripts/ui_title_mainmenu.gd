# ui_title_main.gd
class_name UI_TitleMainMenu
extends Control

func _on_button_loadgame_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.loadmenu

func _on_button_newgame_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.newmenu

func _on_button_options_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.optionmenu

func _on_button_quit_pressed() -> void:
	Ref.main.quit()
