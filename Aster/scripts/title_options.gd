# title_options.gd
class_name TitleOptions
extends TitleBase

func _on_button_back_pressed():
	Ref.ui.title.main.make_current()
