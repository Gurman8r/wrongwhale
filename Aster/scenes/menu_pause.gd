# menu_pause.gd
class_name MenuPause
extends PanelContainer

func _on_button_resume_pressed():
	pass

func _on_button_quit_pressed():
	get_tree().quit()
