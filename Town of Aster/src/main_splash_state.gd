# main_splash_state.gd
class_name MainSplashState
extends MainState

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var icon_textures: Array[Texture] = [ Prefabs.GODOT_ICON ]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# wait a second so everything can snap into place
	Splash.timer.start(1.0)
	await Splash.timer.timeout
	
	# skip splash
	if Settings.get_("splash_delay") <= 0.0:
		Debug.puts(" | nosplash")
		Game.main.change_state(Game.main.title_state)
		Transition.play("fadein")
		await Transition.finished
		return
	
	# play splash
	Splash.canvas_layer.show()
	Splash.overlay.show()
	for i in range(icon_textures.size()):
		var t: Texture = icon_textures[i]
		if not t: continue
		Splash.overlay.icon.texture = t
		Transition.play("fadein")
		await Transition.finished
		Debug.puts(" | splash%d" % [i])
		Splash.timer.start(Settings.get_("splash_delay"))
		await Splash.timer.timeout
		Transition.play("fadeout")
		await Transition.finished
	Game.main.change_state(Game.main.title_state)
	Transition.play("fadein")
	await Transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _exit_state() -> void:
	super._exit_state()
	Splash.timer.stop()
	Splash.overlay.hide()
	Splash.canvas_layer.show()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
