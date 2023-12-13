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
	
	# skip splash
	if Settings.data.skip_splash:
		print("SKIP_SPLASH")
		Game.main.change_state(Game.title_state)
		return
	
	# play splash
	# TODO splash screen goes here
	print("PLAY_SPLASH")
	Game.main.change_state(Game.title_state)

func _exit_state() -> void:
	super._exit_state()
	Splash.timer.stop()
	Splash.overlay.hide()

func _physics_process(_delta) -> void:
	pass
