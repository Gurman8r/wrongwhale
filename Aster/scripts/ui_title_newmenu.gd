# ui_title_newmenu.gd
class_name UI_TitleNewMenu
extends Control

const default_world = preload("res://resources/data/default_world.tres")

@export var world_data: WorldData

func _on_button_play_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ref.ui.transition.play("fadeout")
	await Ref.ui.transition.finished
	Ref.ui.title.hide()
	
	Ref.world.load_data(world_data)
	Ref.world.show()
	Ref.ui.hud.show()
	
	Ref.ui.transition.play("fadein")
	await Ref.ui.transition.finished
	Ref.main.playing = true
	get_tree().paused = false

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
