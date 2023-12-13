# splash_state.gd
class_name SplashState
extends State

const GODOT_ICON = preload("res://icon.svg")

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Splash.timer.start(Settings.data.splash_delay)
	await Splash.timer.timeout
	
	Transition.play("fadein")
	await Transition.finished
	
	if Settings.data.skip_splash:
		Game.main.change_state(Game.title_state)
		return
	
	print("SPLASH")
	# TODO splash goes here
	Game.main.change_state(Game.title_state)
	

func _exit_state() -> void:
	super._exit_state()
	Splash.timer.stop()
	Splash.overlay.hide()

func _physics_process(_delta) -> void:
	pass
