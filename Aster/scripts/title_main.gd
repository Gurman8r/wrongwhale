# title_main.gd
class_name TitleMain
extends TitleBase

func _on_button_loadgame_pressed() -> void:
	Ref.ui.title.loadgame.make_current()

func _on_button_newgame_pressed() -> void:
	Ref.ui.title.newgame.make_current()

func _on_button_options_pressed() -> void:
	Ref.ui.title.options.make_current()

func _on_button_quit_pressed() -> void:
	Ref.ui.transition.play_fadeout()
	await Ref.ui.transition.finished
	get_tree().quit()
