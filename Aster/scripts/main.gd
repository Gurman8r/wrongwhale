# main.gd
class_name Main
extends Node

signal quitting()

@onready var settings: Settings = $Settings
@onready var world: World = $World
@onready var ui : UI = $UI
@onready var player: Player = Ref.player

var good2go: bool = false
var playing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.main = self

func _ready() -> void:
	get_tree().paused = true
	
	for node in get_tree().get_nodes_in_group("load"):
		if not "load_data" in node or world.loading.is_connected(node.load_data): continue
		world.loading.connect(node.load_data)
	for node in get_tree().get_nodes_in_group("save"):
		if not "save_data" in node or world.saving.is_connected(node.save_data): continue
		world.saving.connect(node.save_data)
	
	player.toggle_inventory.connect(ui.game.toggle_inventory)
	ui.game.set_player_inventory_data(player.data.inventory)
	ui.game.set_equip_inventory_data(player.data.equip)
	ui.hud.hotbar.set_inventory_data(player.data.inventory)
	for node in get_tree().get_nodes_in_group("external_inventory"):
		if not "toggle_inventory" in node or node.toggle_inventory.is_connected(ui.game.toggle_inventory): continue
		node.toggle_inventory.connect(ui.game.toggle_inventory)
	
	good2go = true # done with setup

func _unhandled_input(_event) -> void:
	if playing and Input.is_action_just_pressed("ui_cancel"):
		unload_world()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func quit() -> void:
	get_tree().paused = true
	ui.transition.play("fadeout")
	await ui.transition.finished
	quitting.emit()
	get_tree().quit()

func read_world(path_stem: String) -> void:
	load_world(WorldData.read(path_stem))

func load_world(world_data: WorldData) -> void:
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.title.current = null
	# load
	world.load_from_memory(world_data)
	# post-load
	ui.hud.show()
	ui.transition.play("fadein")
	await ui.transition.finished
	playing = true
	get_tree().paused = false

func save_world(path_stem: String) -> void:
	world.save_data(path_stem)

func unload_world() -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.hud.hide()
	# save
	world.save_to_file("save0")
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.mainmenu
	ui.transition.play("fadein")
	await ui.transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
