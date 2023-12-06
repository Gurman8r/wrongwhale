# main.gd
class_name Main
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var world: World = $World
@onready var ui: UI = $UI

var playing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not G.main)
	G.main = self

func _ready() -> void:
	get_tree().paused = true
	
	# LOADED
	world.loading_finished.connect(func():
		ui.game.set_player_data(G.player.data)
		G.player.toggle_debug.connect(ui.debug.toggle)
		G.player.toggle_inventory.connect(ui.game.toggle_inventory)
		G.player.hotbar_next.connect(ui.game.hotbar_inventory.next)
		G.player.hotbar_prev.connect(ui.game.hotbar_inventory.prev)
		G.player.hotbar_select.connect(ui.game.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.connect(ui.game.toggle_inventory))
	
	# UNLOADED
	world.unloading_started.connect(func():
		ui.game.clear_player_data()
		G.player.toggle_debug.disconnect(ui.debug.toggle)
		G.player.toggle_inventory.disconnect(ui.game.toggle_inventory)
		G.player.hotbar_next.disconnect(ui.game.hotbar_inventory.next)
		G.player.hotbar_prev.disconnect(ui.game.hotbar_inventory.prev)
		G.player.hotbar_select.disconnect(ui.game.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.disconnect(ui.game.toggle_inventory))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if not playing \
	and ui.title.current_menu == ui.title.main \
	and Input.is_action_just_pressed("ui_cancel"):
		quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region FLOW_CONTROL

func load_world_from_memory(world_data: WorldData) -> void:
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	ui.title.current_menu = null
	# load
	world.load_from_memory(world_data)
	# post-load
	ui.game.show()
	ui.transitions.play("fadein")
	await ui.transitions.finished
	playing = true
	get_tree().paused = false

func load_world_from_file(path_stem: String) -> void:
	load_world_from_memory(WorldData.read(path_stem))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save_world_to_file_and_quit_to_desktop(path_stem: String = "") -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
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
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	ui.game.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	ui.title.current_menu = ui.title.main
	ui.transitions.play("fadein")
	await ui.transitions.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func quit_to_desktop() -> void:
	get_tree().paused = true
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	get_tree().quit()

func quit_to_title() -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transitions.play("fadeout")
	await ui.transitions.finished
	ui.game.hide()
	# unload
	world.unload()
	# post-unload
	ui.title.current_menu = ui.title.main
	ui.transitions.play("fadein")
	await ui.transitions.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
