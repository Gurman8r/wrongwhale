# title_state.gd
class_name TitleState
extends State

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Title.interface.menu = Title.interface.home
	
	Transition.play("fadein")
	await Transition.finished
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _exit_state() -> void:
	super._exit_state()
	
	Transition.play("fadeout")
	await Transition.finished
	
	Title.interface.menu = null

func _physics_process(_delta) -> void:
	pass
