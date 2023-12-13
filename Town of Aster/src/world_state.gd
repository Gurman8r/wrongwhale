# world_state.gd
class_name WorldState
extends State

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	World.reload()
	Player.overlay.show()
	Player.interface.show()
	Game.unpause()

func _exit_state() -> void:
	super._exit_state()
	Player.overlay.hide()
	Player.interface.hide()
