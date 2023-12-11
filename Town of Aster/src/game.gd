# game.gd
# Game
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const DATA_DIR := "user://data"
const MODS_DIR := "user://mods"
const SAVES_DIR := "user://saves"

enum { SPLASH_STATE, TITLE_STATE, WORLD_STATE }
const STATES := [ "SplashState", "TitleState", "WorldState" ]
@onready var main: StateMachine = $"../Main"
@onready var splash_state = main.get_node(STATES[SPLASH_STATE])
@onready var title_state = main.get_node(STATES[TITLE_STATE])
@onready var world_state = main.get_node(STATES[WORLD_STATE])

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	super._init()
	DirAccess.make_dir_absolute(DATA_DIR)
	DirAccess.make_dir_absolute(MODS_DIR)
	DirAccess.make_dir_absolute(SAVES_DIR)

func _ready() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Title.interface.menu == Title.interface.home \
	and Input.is_action_just_pressed("toggle_pause"):
		Game.quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region CONTROL_FLOW

func quit_to_desktop() -> void:
	get_tree().paused = true
	Transition.play("fadeout")
	await Transition.finished
	get_tree().quit()

func quit_to_title() -> void:
	# pre-unload
	get_tree().paused = true
	Transition.play("fadeout")
	await Transition.finished
	Player.interface.hide()
	Player.overlay.hide()
	# unload
	World.unload()
	# post-unload
	Title.interface.menu = Title.interface.home
	Transition.play("fadein")
	await Transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func load_world_from_memory(world_data: WorldData) -> void:
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Transition.play("fadeout")
	await Transition.finished
	Title.interface.menu = null
	# load
	World.load_from_memory(world_data)
	# post-load
	Player.interface.show()
	Player.overlay.show()
	Transition.play("fadein")
	await Transition.finished
	get_tree().paused = false

func load_world_from_file(path_stem: String) -> void:
	load_world_from_memory(WorldData.read(path_stem))

func save_world_to_file_and_quit_to_desktop(path_stem: String = "") -> void:
	# pre-unload
	get_tree().paused = true
	Transition.play("fadeout")
	await Transition.finished
	Player.interface.hide()
	Player.overlay.hide()
	# save
	World.save_to_file(path_stem)
	# unload
	World.unload()
	# post-unload
	get_tree().quit()

func save_world_to_file_and_quit_to_title(path_stem: String = "") -> void:
	# pre-unload
	get_tree().paused = true
	Transition.play("fadeout")
	await Transition.finished
	Player.interface.hide()
	Player.overlay.hide()
	# save
	World.save_to_file(path_stem)
	# unload
	World.unload()
	# post-unload
	Title.interface.menu = Title.interface.home
	Transition.play("fadein")
	await Transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
