# splash_state.gd
class_name SplashState
extends State

const GODOT_ICON = preload("res://icon.svg")

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Splash.timer.start(1.0)
	await Splash.timer.timeout
	
	if not Settings.data.skip_splash:
		Splash.overlay.show()
		
		Splash.overlay.icon.texture = GODOT_ICON
		Transition.play("fadein")
		await Transition.finished
		Splash.timer.start(1.0)
		await Splash.timer.timeout
		Transition.play("fadeout")
		await Transition.finished
	
	Game.main.change_state(Game.title_state)

func _exit_state() -> void:
	super._exit_state()
	Splash.timer.stop()
	Splash.overlay.hide()

func _physics_process(_delta) -> void:
	pass
