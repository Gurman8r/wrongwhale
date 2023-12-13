# game_controller.gd
# Game
extends SystemController

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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Title.interface.menu == Title.interface.home \
	and Input.is_action_just_pressed("toggle_pause"):
		Game.quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region FLOW_CONTROL

func load_from_memory(world_data: WorldData) -> void:
	print("|# LOAD_FROM_MEMORY")
	Transition.play("fadeout")
	await Transition.finished
	World.data = world_data
	main.change_state(world_state)
	Transition.play("fadein")
	await Transition.finished

func load_from_file(path_stem: String) -> void:
	print("|# LOAD_FROM_FILE")
	Transition.play("fadeout")
	await Transition.finished
	World.data = WorldData.read(path_stem)
	main.change_state(world_state)
	Transition.play("fadein")
	await Transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func quit_to_desktop() -> void:
	print("|# QUIT_TO_DESKTOP")
	Transition.play("fadeout")
	await Transition.finished
	get_tree().quit()

func save_to_file_and_quit_to_desktop(path_stem: String = "") -> void:
	print("|# SAVE_TO_FILE_AND_QUIT_TO_DESKTOP")
	Transition.play("fadeout")
	await Transition.finished
	World.save(path_stem)
	World.unload()
	get_tree().quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func quit_to_title() -> void:
	print("|# QUIT_TO_TITLE")
	Transition.play("fadeout")
	await Transition.finished
	World.unload()
	main.change_state(title_state)
	Transition.play("fadein")
	await Transition.finished

func save_to_file_and_quit_to_title(path_stem: String = "") -> void:
	print("|# SAVE_TO_FILE_AND_QUIT_TO_TITLE")
	Transition.play("fadeout")
	await Transition.finished
	World.save(path_stem)
	World.unload()
	main.change_state(title_state)
	Transition.play("fadein")
	await Transition.finished

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
