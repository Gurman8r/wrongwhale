# title_state.gd
class_name TitleState
extends State

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Title.canvas.show()
	Title.interface.menu = Title.interface.home

func _exit_state() -> void:
	super._exit_state()
	Title.interface.menu = null
	Title.canvas.hide()

func _physics_process(_delta) -> void:
	pass
