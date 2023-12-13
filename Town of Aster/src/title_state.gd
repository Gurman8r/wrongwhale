# title_state.gd
class_name TitleState
extends State

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Title.canvas.show()
	Title.interface.menu = Title.interface.home

func _exit_state() -> void:
	super._exit_state()
	Title.interface.menu = null
