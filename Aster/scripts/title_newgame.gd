# title_newgame.gd
class_name TitleNewgame
extends Control

func _on_button_play_pressed():
	Ref.ui.title_interface.hide()
	# load world data here
	Ref.world.show()
	Ref.ui.game_overlay.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ref.main.playing = true
	get_tree().paused = false

func _on_button_back_pressed():
	Ref.ui.title_interface.current = Ref.ui.title_interface.mainmenu
