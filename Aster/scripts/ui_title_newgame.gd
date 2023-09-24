# ui_title_newgame.gd
class_name UI_TitleNewgame
extends Control

func _on_button_play_pressed():
	Ref.ui.transition.fadeout()
	await Ref.ui.transition.finished
	Ref.ui.title.hide()
	Ref.ui.hud.show()
	
	# load game here
	
	Ref.world.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ref.main.playing = true
	get_tree().paused = false
	
	Ref.ui.transition.fadein()
	await Ref.ui.transition.finished

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
