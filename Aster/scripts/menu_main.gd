# menu_main.gd
class_name MenuMain
extends Menu

func _on_button_loadgame_pressed() -> void:
	Game.ui.menu.current = Game.ui.menu.menu_loadgame

func _on_button_newgame_pressed() -> void:
	Game.ui.menu.current = Game.ui.menu.menu_newgame

func _on_button_options_pressed() -> void:
	Game.ui.menu.current = Game.ui.menu.menu_options

func _on_button_quit_pressed() -> void:
	get_tree().quit()
