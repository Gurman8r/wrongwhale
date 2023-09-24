# title_main.gd
class_name TitleMain
extends TitleBaseMenu

func _on_button_loadgame_pressed() -> void:
	Ref.ui.title_interface.loadgame.show()

func _on_button_newgame_pressed() -> void:
	Ref.ui.title_interface.newgame.show()

func _on_button_options_pressed() -> void:
	Ref.ui.title_interface.options.show()

func _on_button_quit_pressed() -> void:
	get_tree().quit()
