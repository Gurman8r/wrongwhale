# main_splash_state.gd
class_name MainSplashState
extends MainState

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var splash_textures: Array[String] = [ "res://icon.svg", ]

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
		return
	
	# play splash
	Splash.canvas_layer.show()
	Splash.overlay.show()
	for i in range(splash_textures.size()):
		Splash.overlay.icon.texture = ImageTexture.create_from_image(Image.load_from_file(splash_textures[i]))
		Transition.play("fadein")
		await Transition.finished
		Debug.puts(" | splash: %s" % [splash_textures[i]])
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
