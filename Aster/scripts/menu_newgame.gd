# menu_newgame.gd
class_name MenuNewgame
extends Menu

func _on_button_play_pressed():
	var world: World = Game.world
	

func _on_button_back_pressed():
	Game.ui.menu_interface.show_menu(Game.ui.menu_interface.menu_main)
