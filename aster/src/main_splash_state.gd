# main_splash_state.gd
class_name MainSplashState
extends MainState

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const splashes := [
	"res://assets/icons/icon_godot.svg",
	#"res://icon.svg",
]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _enter_state() -> void:
	super._enter_state()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# wait a second so everything can snap into place
	Splash.timer.start(1.0)
	await Splash.timer.timeout
	
	var splash_delay = Settings.get_setting("splash_delay")
	
	# skip splash
	if splash_delay <= 0.0:
		print(" | nosplash")
		Game.main.state = Game.main.title_state
		Transition.play("fadein")
		await Transition.finished
	# play splash
	else:
		Splash.canvas_layer.show()
		Splash.overlay.show()
		for i in range(splashes.size()):
			var path = splashes[i]
			var gpath = ProjectSettings.globalize_path(path)
			if FileAccess.file_exists(gpath): path = gpath
			#Splash.overlay.icon.texture = ImageTexture.create_from_image(Image.load_from_file(path))
			Splash.overlay.icon.texture = load(path)
			Transition.play("fadein")
			await Transition.finished
			print(" | splash: %s" % [splashes[i]])
			Splash.timer.start(splash_delay)
			await Splash.timer.timeout
			Transition.play("fadeout")
			await Transition.finished
			Splash.timer.start(splash_delay)
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
