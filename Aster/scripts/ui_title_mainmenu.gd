# ui_title_main.gd
class_name UI_TitleMainmenu
extends Control

func _on_button_loadgame_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.loadgame

func _on_button_newgame_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.newgame

func _on_button_options_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.options

func _on_button_quit_pressed() -> void:
	Ref.ui.transition.play_fadeout()
	await Ref.ui.transition.finished
	get_tree().quit()
