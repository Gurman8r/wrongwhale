# world_state.gd
class_name WorldState
extends State

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	World.reload()
	Player.canvas.show()
	Player.interface.show()
	Player.overlay.hide()

func _exit_state() -> void:
	super._exit_state()
	Player.canvas.hide()
	Player.interface.hide()
	Player.overlay.hide()

func _physics_process(_delta) -> void:
	pass
