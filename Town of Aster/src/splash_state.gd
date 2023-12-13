# splash_state.gd
class_name SplashState
extends State

const GODOT_ICON = preload("res://icon.svg")

var icon_textures: Array[Texture] = [ GODOT_ICON ]

func _enter_state() -> void:
	super._enter_state()
	Game.pause()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# brief pause so everything can snap into place
	Splash.timer.start(0.5)
	await Splash.timer.timeout
	
	# skip splash
	var delay: float = Settings.data.splash_delay
	if delay <= 0.0:
		print("$: nosplash")
		Game.main.change_state(Game.title_state)
		Transition.play("fadein")
		await Transition.finished
		return
	
	# play splash
	Splash.canvas.show()
	Splash.overlay.show()
	for i in range(icon_textures.size()):
		var t: Texture = icon_textures[i]
		if not t: continue
		print("$: splash%d" % [i])
		Splash.overlay.icon.texture = t
		Transition.play("fadein")
		await Transition.finished
		Splash.timer.start(delay)
		await Splash.timer.timeout
		Transition.play("fadeout")
		await Transition.finished
	
	Game.main.change_state(Game.title_state)
	Transition.play("fadein")
	await Transition.finished

func _exit_state() -> void:
	super._exit_state()
	Splash.timer.stop()
	Splash.overlay.hide()
	Splash.canvas.show()
