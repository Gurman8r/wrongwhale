# main.gd
class_name Main
extends Node

signal quitting()

@onready var settings: Settings = $Settings
@onready var world: World = $World
@onready var ui: UI = $UI
@onready var player: Player = Ref.player

var playing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.main = self

func _ready() -> void:
	get_tree().paused = true
	
	# save/load connections
	for node in get_tree().get_nodes_in_group("load"):
		assert("load_from_memory" in node)
		world.loading.connect(node.load_from_memory)
	for node in get_tree().get_nodes_in_group("save"):
		assert("save_to_memory" in node)
		world.saving.connect(node.save_to_memory)
	
	# player ui connections
	player.toggle_debug.connect(ui.debug.toggle)
	player.toggle_inventory.connect(ui.game.toggle_inventory)
	player.hotbar_next.connect(ui.hud.hotbar.next)
	player.hotbar_prev.connect(ui.hud.hotbar.prev)
	player.hotbar_select.connect(ui.hud.hotbar.set_item_index)
	world.loading_finished.connect(func(): ui.set_player_data(player.data))
	world.unloading.connect(ui.game.clear_player_data)
	
	# external inventory connections
	for node in get_tree().get_nodes_in_group("external_inventory"):
		assert("toggle_inventory" in node)
		node.toggle_inventory.connect(ui.game.toggle_inventory)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if playing:
			save_and_quit_to_title()
		else:
			quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_game(world_data: WorldData, transition: bool = true) -> void:
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if transition:
		ui.transition.play("fadeout")
		await ui.transition.finished
	ui.title.current = null
	# load
	world.load_from_memory(world_data)
	# post-load
	ui.hud.show()
	if transition:
		ui.transition.play("fadein")
		await ui.transition.finished
	playing = true
	get_tree().paused = false

func save_and_quit(path_stem: String = "save0", transition: bool = true) -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	if transition:
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
	
func save_and_quit_to_title(path_stem: String = "save0", transition: bool = true) -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	if transition:
		ui.transition.play("fadeout")
		await ui.transition.finished
	ui.hud.hide()
	# save
	world.save_to_file(path_stem)
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.mainmenu
	if transition:
		ui.transition.play("fadein")
		await ui.transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func quit(transition: bool = true) -> void:
	get_tree().paused = true
	if transition:
		ui.transition.play("fadeout")
		await ui.transition.finished
	quitting.emit()
	get_tree().quit()

func quit_to_title(transition: bool = true) -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	if transition:
		ui.transition.play("fadeout")
		await ui.transition.finished
	ui.hud.hide()
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.mainmenu
	if transition:
		ui.transition.play("fadein")
		await ui.transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
