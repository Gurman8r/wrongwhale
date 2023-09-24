# title_options.gd
class_name TitleOptions
extends TitleBaseMenu

func _on_button_back_pressed():
	Ref.ui.title_interface.main.show()
