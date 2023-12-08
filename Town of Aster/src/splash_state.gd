# splash_state.gd
class_name SplashState
extends State

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Game.main.change_state(Game.title_state)

func _exit_state() -> void:
	super._exit_state()

func _physics_process(_delta) -> void:
	pass
