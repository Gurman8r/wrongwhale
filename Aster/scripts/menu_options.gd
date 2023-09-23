# menu_options.gd
class_name MenuOptions
extends Menu

func _on_button_back_pressed():
	Game.ui.menu_interface.show_menu(Game.ui.menu_interface.menu_main)
