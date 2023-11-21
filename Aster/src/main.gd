# main.gd
class_name Main
extends Node

@onready var database : Database = $Database
@onready var settings : Settings = $Settings
@onready var world    : World    = $World
@onready var ui       : UI       = $UI

var playing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.main)
	Ref.main = self

func _ready() -> void:
	get_tree().paused = true
	
	# LOADED
	world.loading_finished.connect(func():
		ui.game.set_player_data(Ref.player.data)
		Ref.player.toggle_debug.connect(ui.debug.toggle)
		Ref.player.toggle_inventory.connect(ui.game.toggle_inventory)
		Ref.player.hotbar_next.connect(ui.game.hotbar_inventory.next)
		Ref.player.hotbar_prev.connect(ui.game.hotbar_inventory.prev)
		Ref.player.hotbar_select.connect(ui.game.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.connect(ui.game.toggle_inventory))
	
	# UNLOADED
	world.unloading_started.connect(func():
		ui.game.clear_player_data()
		Ref.player.toggle_debug.disconnect(ui.debug.toggle)
		Ref.player.toggle_inventory.disconnect(ui.game.toggle_inventory)
		Ref.player.hotbar_inventory.next.disconnect(ui.game.hotbar_inventory.next)
		Ref.player.hotbar_inventory.prev.disconnect(ui.game.hotbar_inventory.prev)
		Ref.player.hotbar_inventory.select.disconnect(ui.game.hotbar_inventory.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.disconnect(ui.game.toggle_inventory))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if playing: save_world_to_file_and_quit_to_title()
		elif ui.title.current_menu == ui.title.main_menu: quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

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
	ui.game.overlay.show()
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
	ui.game.overlay.hide()
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
	ui.game.overlay.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	ui.title.current_menu = ui.title.main_menu
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
	ui.game.overlay.hide()
	# unload
	world.unload()
	# post-unload
	ui.title.current_menu = ui.title.main_menu
	ui.transitions.play("fadein")
	await ui.transitions.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
