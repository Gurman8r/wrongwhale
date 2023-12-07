# game.gd
# Game
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const DATA_DIR := "user://data"
const MODS_DIR := "user://mods"
const SAVES_DIR := "user://saves"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var main     : Main
var world    : World
var ui       : UI
var player   : Player

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# STATE
enum { STATE_TITLE, STATE_LOADING, STATE_PLAYING, STATE_QUITTING, }
var state: int = STATE_TITLE
func set_state(value: int) -> void: state = value
func is_playing() -> bool: return state == STATE_PLAYING

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	get_tree().paused = true
	
	DirAccess.make_dir_absolute(DATA_DIR)
	DirAccess.make_dir_absolute(MODS_DIR)
	DirAccess.make_dir_absolute(SAVES_DIR)

	# LOADED
	world.loading_finished.connect(func():
		ui.game.set_player_data(player.data)
		player.toggle_debug.connect(ui.debug.toggle)
		player.toggle_inventory.connect(ui.game.toggle_inventory)
		player.hotbar_next.connect(ui.game.hotbar_inventory.next)
		player.hotbar_prev.connect(ui.game.hotbar_inventory.prev)
		player.hotbar_select.connect(ui.game.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.connect(ui.game.toggle_inventory))
	
	# UNLOADED
	world.unloading_started.connect(func():
		ui.game.clear_player_data()
		player.toggle_debug.disconnect(ui.debug.toggle)
		player.toggle_inventory.disconnect(ui.game.toggle_inventory)
		player.hotbar_next.disconnect(ui.game.hotbar_inventory.next)
		player.hotbar_prev.disconnect(ui.game.hotbar_inventory.prev)
		player.hotbar_select.disconnect(ui.game.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.disconnect(ui.game.toggle_inventory))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Game.is_playing() \
	and Game.ui.title.current == ui.title.home \
	and Input.is_action_just_pressed("toggle_pause"):
		Game.quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region QUIT_GAME

func quit_to_desktop() -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING: return
	else: state = STATE_QUITTING
	get_tree().paused = true
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	get_tree().quit()

func quit_to_title() -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING \
	or state == STATE_TITLE: return
	else: state = STATE_TITLE
	# pre-unload
	get_tree().paused = true
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	ui.game.hide()
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.home
	ui.transitions.play("fadein")
	await ui.transitions.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#endregion

#region LOAD_GAME

func load_world_from_memory(world_data: WorldData) -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING: return
	else: state = STATE_LOADING
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	ui.title.current = null
	# load
	world.load_from_memory(world_data)
	# post-load
	ui.game.show()
	ui.transitions.play("fadein")
	await ui.transitions.finished
	state = STATE_PLAYING
	get_tree().paused = false

func load_world_from_file(path_stem: String) -> void:
	load_world_from_memory(WorldData.read(path_stem))

#endregion

#region SAVE_GAME

func save_world_to_file_and_quit_to_desktop(path_stem: String = "") -> void:
	if state == STATE_QUITTING \
	or state == STATE_LOADING: return
	else: state = STATE_QUITTING
	# pre-unload
	get_tree().paused = true
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	ui.game.hide()
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
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	ui.game.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.home
	ui.transitions.play("fadein")
	await ui.transitions.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
