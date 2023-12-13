# world_state.gd
class_name WorldState
extends State

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	World.reload()
	assert(Player.canvas.visible)
	Player.overlay.show()
	Player.interface.show()
	get_tree().paused = false

func _exit_state() -> void:
	super._exit_state()
	Player.overlay.hide()
	Player.interface.hide()

func _physics_process(_delta) -> void:
	pass
