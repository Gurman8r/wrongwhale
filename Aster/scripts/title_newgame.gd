# title_newgame.gd
class_name TitleNewgame
extends Control

func _on_button_play_pressed():
	Ref.ui.transition.play_fadeout()
	await Ref.ui.transition.finished
	
	Ref.ui.title.hide()
	# load world data here
	Ref.world.show()
	Ref.ui.hud.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ref.main.playing = true
	get_tree().paused = false
	
	Ref.ui.transition.play_fadein()
	await Ref.ui.transition.finished

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.main
