# menu_newgame.gd
class_name MenuNewgame
extends Menu

@export var save_data: SaveData

func _on_button_play_pressed():
	Game.ui.menu_interface.show_menu(null)
	Game.ui.toggle_menu_interface()
	Game.world.show()
	Game.ui.toggle_hud()

func _on_button_back_pressed():
	Game.ui.menu_interface.show_menu(Game.ui.menu_interface.menu_main)
