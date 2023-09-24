# title_loadgame.gd
class_name TitleLoadgame
extends TitleBase

func _on_button_back_pressed() -> void:
	Ref.ui.title.main.make_current()
