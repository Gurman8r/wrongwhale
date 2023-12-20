# main_splash_state.gd
class_name MainSplashState
extends MainState

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var splashes: Array[String] = [
	"res://assets/icons/icon_godot.png",
]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# wait a second so everything can snap into place
	Splash.timer.start(1.0)
	await Splash.timer.timeout
	
	# skip splash
	if Settings.get_setting("splash_delay") <= 0.0:
		Debug.puts(" | nosplash")
		Game.main.state = Game.main.title_state
		Transition.play("fadein")
		await Transition.finished
	
	# play splash
	else:
		Splash.canvas_layer.show()
		Splash.overlay.show()
		for i in range(splashes.size()):
			Splash.overlay.icon.texture = Util.load_texture(splashes[i])
			Transition.play("fadein")
			await Transition.finished
			Debug.puts(" | splash: %s" % [splashes[i]])
			Splash.timer.start(Settings.get_setting("splash_delay"))
			await Splash.timer.timeout
			Transition.play("fadeout")
			await Transition.finished
			Splash.timer.start(Settings.get_setting("splash_delay"))
			await Splash.timer.timeout
		Game.main.state = Game.main.title_state
		Transition.play("fadein")
		await Transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _exit_state() -> void:
	super._exit_state()
	Splash.timer.stop()
	Splash.overlay.hide()
	Splash.canvas_layer.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
