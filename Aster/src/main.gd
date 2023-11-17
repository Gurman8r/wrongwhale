# main.gd
class_name Main
extends Node

signal quitting()

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
	
	# WORLD LOADED
	world.loading_finished.connect(func():
		ui.set_player_data(Ref.player.data)
		Ref.player.toggle_debug.connect(ui.debug.toggle)
		Ref.player.toggle_inventory.connect(ui.game.toggle_inventory)
		Ref.player.hotbar_next.connect(ui.hud.hotbar.next)
		Ref.player.hotbar_prev.connect(ui.hud.hotbar.prev)
		Ref.player.hotbar_select.connect(ui.hud.hotbar.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.connect(ui.game.toggle_inventory)
		pass)
	
	# WORLD UNLOADED
	world.unloading_started.connect(func():
		ui.clear_player_data()
		Ref.player.toggle_debug.disconnect(ui.debug.toggle)
		Ref.player.toggle_inventory.disconnect(ui.game.toggle_inventory)
		Ref.player.hotbar_next.disconnect(ui.hud.hotbar.next)
		Ref.player.hotbar_prev.disconnect(ui.hud.hotbar.prev)
		Ref.player.hotbar_select.disconnect(ui.hud.hotbar.set_item_index)
		for node in get_tree().get_nodes_in_group("external_inventory"):
			node.toggle_inventory.disconnect(ui.game.toggle_inventory)
		pass)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if playing:
			save_to_file_and_quit_to_title("World_New")
		else:
			quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func play(world_data: WorldData) -> void:
	# pre-load
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.title.current = null
	# load
	world.load_data(world_data)
	# post-load
	ui.hud.show()
	ui.transition.play("fadein")
	await ui.transition.finished
	playing = true
	get_tree().paused = false

func play_file(path_stem: String) -> void:
	play(WorldData.read(path_stem))

func save_to_file_and_quit(path_stem: String) -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.hud.hide()
	# save
	world.save_file(path_stem)
	# unload
	world.unload()
	# post-unload
	quitting.emit()
	get_tree().quit()
	
func save_to_file_and_quit_to_title(path_stem: String) -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.hud.hide()
	# save
	world.save_file(path_stem)
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.main
	ui.transition.play("fadein")
	await ui.transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func quit() -> void:
	get_tree().paused = true
	ui.transition.play("fadeout")
	await ui.transition.finished
	quitting.emit()
	get_tree().quit()

func quit_to_title() -> void:
	# pre-unload
	get_tree().paused = true
	playing = false
	ui.transition.play("fadeout")
	await ui.transition.finished
	ui.hud.hide()
	# unload
	world.unload()
	# post-unload
	ui.title.current = ui.title.main
	ui.transition.play("fadein")
	await ui.transition.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
