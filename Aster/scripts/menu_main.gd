# menu_main.gd
class_name MenuMain
extends Menu

func _on_button_loadgame_pressed() -> void:
	Game.ui.menu_interface.show_menu(Game.ui.menu_interface.menu_loadgame)

func _on_button_newgame_pressed() -> void:
	Game.ui.menu_interface.show_menu(Game.ui.menu_interface.menu_newgame)

func _on_button_options_pressed() -> void:
	Game.ui.menu_interface.show_menu(Game.ui.menu_interface.menu_options)

func _on_button_quit_pressed() -> void:
	get_tree().quit()
