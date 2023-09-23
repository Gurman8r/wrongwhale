# menu_loadgame.gd
class_name MenuLoadgame
extends Menu

func _on_button_back_pressed() -> void:
	Game.ui.menu.current = Game.ui.menu.menu_main
