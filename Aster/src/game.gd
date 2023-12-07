# game.gd
# Game
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const DATA_DIR := "user://data"
const MODS_DIR := "user://mods"
const SAVES_DIR := "user://saves"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var main : Node = get_parent().get_node("Main")
var world: World
var player: PlayerCharacter

@onready var ui: CanvasLayer = main.get_node("UI")
var game_ui: GameUI
var title_ui: TitleUI
var transitions_ui: TransitionsUI
var debug_ui: DebugUI

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# STATE
enum { STATE_TITLE, STATE_LOADING, STATE_PLAYING, STATE_QUITTING, }
var state: int = STATE_TITLE
func set_state(value: int) -> void: state = value
func is_title() -> bool: return state == STATE_TITLE
func is_loading() -> bool: return state == STATE_LOADING
func is_playing() -> bool: return state == STATE_PLAYING
func is_quitting() -> bool: return state == STATE_QUITTING

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	assert(main)
	assert(ui)
	get_tree().paused = true
	
	# create file structure
	DirAccess.make_dir_absolute(DATA_DIR)
	DirAccess.make_dir_absolute(MODS_DIR)
	DirAccess.make_dir_absolute(SAVES_DIR)

	# loading finished
	world.loading_finished.connect(func():
		assert(player)
		game_ui.set_player_data(player.data)
		player.toggle_debug.connect(debug_ui.toggle)
		player.toggle_inventory.connect(game_ui.toggle_inventory)
		player.hotbar_next.connect(game_ui.hotbar_inventory.next)
		player.hotbar_prev.connect(game_ui.hotbar_inventory.prev)
		player.hotbar_select.connect(game_ui.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.connect(game_ui.toggle_inventory))
	
	# unloading started
	world.unloading_started.connect(func():
		assert(player)
		game_ui.clear_player_data()
		player.toggle_debug.disconnect(debug_ui.toggle)
		player.toggle_inventory.disconnect(game_ui.toggle_inventory)
		player.hotbar_next.disconnect(game_ui.hotbar_inventory.next)
		player.hotbar_prev.disconnect(game_ui.hotbar_inventory.prev)
		player.hotbar_select.disconnect(game_ui.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.disconnect(game_ui.toggle_inventory))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if not Game.is_playing() \
	and Game.title_ui.current == title_ui.home \
	and Input.is_action_just_pressed("toggle_pause"):
		Game.quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region CONTROL_FLOW

func quit_to_desktop() -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING: return
	else: state = STATE_QUITTING
	get_tree().paused = true
	transitions_ui.play("fadeout")
	await transitions_ui.finished
	get_tree().quit()

func quit_to_title() -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING \
	or state == STATE_TITLE: return
	else: state = STATE_TITLE
	# pre-unload
	get_tree().paused = true
	transitions_ui.play("fadeout")
	await transitions_ui.finished
	game_ui.hide()
	# unload
	world.unload()
	# post-unload
	title_ui.current = title_ui.home
	transitions_ui.play("fadein")
	await transitions_ui.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func load_world_from_memory(world_data: WorldData) -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING: return
	else: state = STATE_LOADING
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	transitions_ui.play("fadeout")
	await transitions_ui.finished
	title_ui.current = null
	# load
	world.load_from_memory(world_data)
	# post-load
	game_ui.show()
	transitions_ui.play("fadein")
	await transitions_ui.finished
	state = STATE_PLAYING
	get_tree().paused = false

func load_world_from_file(path_stem: String) -> void:
	load_world_from_memory(WorldData.read(path_stem))

func save_world_to_file_and_quit_to_desktop(path_stem: String = "") -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING: return
	else: state = STATE_QUITTING
	# pre-unload
	get_tree().paused = true
	transitions_ui.play("fadeout")
	await transitions_ui.finished
	game_ui.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	get_tree().quit()

func save_world_to_file_and_quit_to_title(path_stem: String = "") -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING \
	or state == STATE_TITLE: return
	else: state = STATE_TITLE
	# pre-unload
	get_tree().paused = true
	transitions_ui.play("fadeout")
	await transitions_ui.finished
	game_ui.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	title_ui.current = title_ui.home
	transitions_ui.play("fadein")
	await transitions_ui.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
