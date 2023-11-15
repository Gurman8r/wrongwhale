# main.gd
class_name Main
extends Node

signal quitting()

@onready var settings	: Settings 	= $Settings
@onready var world		: World 	= $World
@onready var ui 		: UI 		= $UI
@onready var player		: Player 	= Ref.player

var good2go: bool = false
var playing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.main = self

func _ready() -> void:
	get_tree().paused = true
	
	# save/load connections
	for node in get_tree().get_nodes_in_group("load"):
		if not "load_from_memory" in node or world.loading.is_connected(node.load_from_memory): continue
		world.loading.connect(node.load_from_memory)
	for node in get_tree().get_nodes_in_group("save"):
		if not "save_to_memory" in node or world.saving.is_connected(node.save_to_memory): continue
		world.saving.connect(node.save_to_memory)
	
	# player ui connections
	world.unloading.connect(ui.game.clear_player_data)
	player.toggle_inventory.connect(ui.game.toggle_inventory)
	player.hotbar_next.connect(ui.hud.hotbar.next)
	player.hotbar_prev.connect(ui.hud.hotbar.prev)
	player.hotbar_select.connect(ui.hud.hotbar.set_item_index)
	
	# external inventory connections
	for node in get_tree().get_nodes_in_group("external_inventory"):
		if not "toggle_inventory" in node or node.toggle_inventory.is_connected(ui.game.toggle_inventory): continue
		node.toggle_inventory.connect(ui.game.toggle_inventory)
	
	good2go = true # done with setup

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if playing and Input.is_action_just_pressed("ui_cancel"):
		save_and_quit_to_title()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_game(world_data: WorldData) -> void:
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.title.current = null
	# load
	world.load_from_memory(world_data)
	# post-load
	ui.set_player_data(player.data)
	ui.hud.show()
	ui.transition.play("fadein")
	await ui.transition.finished
	playing = true
	get_tree().paused = false

func save_and_quit(path_stem: String = "save0") -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.hud.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	quitting.emit()
	get_tree().quit()
	
func save_and_quit_to_title(path_stem: String = "save0") -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.hud.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.mainmenu
	ui.transition.play("fadein")
	await ui.transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func quit() -> void:
	get_tree().paused = true
	ui.transition.play("fadeout")
	await ui.transition.finished
	quitting.emit()
	get_tree().quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
