# title_loadgame.gd
class_name TitleLoadgame
extends TitleMenu

func _on_button_back_pressed() -> void:
	Ref.ui.title_interface.main.show()
