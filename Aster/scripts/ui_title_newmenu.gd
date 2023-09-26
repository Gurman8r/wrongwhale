# ui_title_newmenu.gd
class_name UI_TitleNewMenu
extends Control

func _on_button_play_pressed():
	Ref.ui.transition.play("fadeout")
	await Ref.ui.transition.finished
	Ref.ui.title.hide()
	
	# LOAD WORLD HERE
	
	Ref.world.show()
	Ref.ui.hud.show()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ref.main.playing = true
	Ref.ui.transition.play("fadein")
	await Ref.ui.transition.finished
	get_tree().paused = false

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
