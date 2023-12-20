# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/settings.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: SettingsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	reset()
	
	DisplayServer.window_set_mode(get_("window_mode"))
	DisplayServer.window_set_size(get_("window_size"))
	DisplayServer.window_set_vsync_mode(get_("window_vsync"))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	data = Util.read(PATH)
	if not data:
		data = Prefabs.DEFAULT_SETTINGS.duplicate()
		if !Game.is_standalone():
			Util.write(data, PATH)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_(key: String):
	assert(data)
	assert(key in data)
	return data[key]

func set_(key: String, value) -> void:
	assert(data)
	data[key] = value

func has(key: String) -> bool:
	assert(data)
	return key in data

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
