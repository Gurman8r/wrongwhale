# menu_loadgame.gd
class_name MenuLoadgame
extends Menu

func _on_button_back_pressed() -> void:
	Game.ui.menu_interface.show_menu(Game.ui.menu_interface.menu_main)
