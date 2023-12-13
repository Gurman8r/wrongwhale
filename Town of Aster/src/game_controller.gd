# game_controller.gd
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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Title.interface.menu == Title.interface.home \
	and Input.is_action_just_pressed("toggle_pause"):
		Game.quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region CONTROL_FLOW

func quit_to_desktop() -> void:
	print("quit_to_desktop")
	Transition.play("fadeout")
	await Transition.finished
	get_tree().quit()

func quit_to_title() -> void:
	print("quit_to_title")
	World.unload()
	main.change_state(title_state)

func load_world_from_memory(world_data: WorldData) -> void:
	print("load_world_from_memory")
	World.data = world_data
	main.change_state(world_state)

func load_world_from_file(path_stem: String) -> void:
	print("load_world_from_file")
	World.data = WorldData.read(path_stem)
	main.change_state(world_state)

func save_world_to_file_and_quit_to_desktop(path_stem: String = "") -> void:
	print("save_world_to_file_and_quit_to_desktop")
	Transition.play("fadeout")
	await Transition.finished
	World.save(path_stem)
	World.unload()
	get_tree().quit()

func save_world_to_file_and_quit_to_title(path_stem: String = "") -> void:
	print("save_world_to_file_and_quit_to_title")
	World.save(path_stem)
	World.unload()
	main.change_state(title_state)

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
