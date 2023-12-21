# main_world_state.gd
class_name MainWorldState
extends MainState

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	World.open()
	Player.overlay.show()
	Player.interface.show()
	Game.unpause()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _exit_state() -> void:
	super._exit_state()
	Player.overlay.hide()
	Player.interface.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
