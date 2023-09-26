# main.gd
class_name Main
extends Node

signal world_loading(world_data: WorldData)
signal world_loaded()
signal world_saving(world_data: WorldData)
signal world_saved()
signal world_unloading()
signal world_unloaded()
signal quitting()

const default_world: WorldData = preload("res://resources/data/default_world.tres")
const default_player: PlayerData = preload("res://resources/data/default_player.tres")

@onready var settings: Settings = $Settings
@onready var world: World = $World
@onready var ui : UI = $UI
@onready var player: Player = Ref.player

var test: WorldData
var good2go: bool = false
var playing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.main = self

func _ready() -> void:
	get_tree().paused = true
	
	player.toggle_inventory.connect(ui.game.toggle_inventory)
	ui.game.force_close.connect(ui.game.toggle_inventory)
	ui.game.set_player_inventory_data(player.data.inventory)
	ui.game.set_equip_inventory_data(player.data.equip)
	ui.hud.hotbar.set_inventory_data(player.data.inventory)
	for node in get_tree().get_nodes_in_group("external_inventory"):
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
	
func load_world(world_data: WorldData = null) -> void:
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.title.current = null
	# load
	if WorldData.exists(): world.data = WorldData.read()
	if world_data: world.data = world_data.duplicate()
	elif not world.data: world.data = default_world.duplicate()
	world_loading.emit(world.data)
	world.show()
	# post-load
	ui.hud.show()
	ui.transition.play("fadein")
	await ui.transition.finished
	playing = true
	get_tree().paused = false
	world_loaded.emit()

func save_world() -> void:
	world_saving.emit(world.data)
	WorldData.write(world.data)
	world_saved.emit()

func unload_world() -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.hud.hide()
	# save
	save_world()
	# unload
	world.hide()
	world_unloading.emit()
	# post-unload
	ui.title.current = ui.title.mainmenu
	ui.transition.play("fadein")
	await ui.transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	world_unloaded.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
