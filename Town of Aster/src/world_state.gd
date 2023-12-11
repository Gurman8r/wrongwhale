# world_state.gd
class_name WorldState
extends State

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	Transition.play("fadein")
	await Transition.finished
	
	Player.interface.show()
	Player.overlay.show()
	get_tree().paused = false

func _exit_state() -> void:
	super._exit_state()
	
	Transition.play("fadeout")
	await Transition.finished
	
	Player.interface.hide()
	Player.overlay.hide()

func _physics_process(_delta) -> void:
	pass
