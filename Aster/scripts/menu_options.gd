# menu_options.gd
class_name MenuOptions
extends Menu

func _on_button_back_pressed():
	Game.ui.menu.current = Game.ui.menu.menu_main
