# menu_newgame.gd
class_name MenuNewgame
extends Menu

func _on_button_play_pressed():
	Game.ui.menu.hide()
	# load world data here
	Game.world.show()
	Game.ui.hud.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Game.main.playing = true
	get_tree().paused = false

func _on_button_back_pressed():
	Game.ui.menu.current = Game.ui.menu.menu_main
