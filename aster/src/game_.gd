# game_.gd
# Game
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var main: Main = $"../Main"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	get_tree().paused = true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _notification(what) -> void:
	match what:
		Node.NOTIFICATION_WM_CLOSE_REQUEST:
			main.force_exit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Title.interface.menu == Title.interface.home \
	and Input.is_physical_key_pressed(KEY_ESCAPE):
		Game.quit_to_desktop()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region PAUSE

var paused: bool : get = get_paused, set = set_paused

func get_paused() -> bool: return get_tree().paused

func pause() -> void: set_paused(true)

func unpause() -> void: set_paused(false)

func toggle_pause() -> void: set_paused(!get_paused())

func set_paused(value: bool) -> void:
	if value: print(" | pause")
	else: print(" | unpause ")
	get_tree().paused = value

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region FLOW_CONTROL

func load_from_memory(world_data: WorldData) -> void:
	print(" | reload")
	Transition.play("fadeout")
	await Transition.finished
	World.data = world_data
	main.state = main.world_state
	Transition.play("fadein")
	await Transition.finished

func load_from_file(path_stem: String) -> void:
	print(" | load_from_file")
	Transition.play("fadeout")
	await Transition.finished
	World.data = WorldData.read(path_stem)
	main.state = main.world_state
	Transition.play("fadein")
	await Transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save(path_stem: String = "") -> void:
	print(" | save")
	World.save(path_stem)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func quit_to_desktop() -> void:
	print(" | quit_to_desktop")
	Transition.play("fadeout")
	await Transition.finished
	main.force_exit()
	get_tree().quit()

func save_and_quit_to_desktop(path_stem: String = "") -> void:
	print(" | save_and_quit_to_desktop")
	Transition.play("fadeout")
	await Transition.finished
	World.save(path_stem)
	World.unload()
	main.force_exit()
	get_tree().quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func quit_to_title() -> void:
	print(" | quit_to_title")
	Transition.play("fadeout")
	await Transition.finished
	World.unload()
	main.state = main.title_state
	Transition.play("fadein")
	await Transition.finished

func save_and_quit_to_title(path_stem: String = "") -> void:
	print(" | save_and_quit_to_title")
	Transition.play("fadeout")
	await Transition.finished
	World.save(path_stem)
	World.unload()
	main.state = main.title_state
	Transition.play("fadein")
	await Transition.finished

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region FEATURES

func is_debug() -> bool: return OS.is_debug_build()

func is_standalone() -> bool: return OS.has_feature("standalone")

func is_editor() -> bool: return !is_standalone()

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
