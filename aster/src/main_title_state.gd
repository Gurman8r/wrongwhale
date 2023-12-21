# main_title_state.gd
class_name MainTitleState
extends MainState

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Title.gui.menu = Title.gui.home

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _exit_state() -> void:
	super._exit_state()
	Title.gui.menu = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
