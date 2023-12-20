# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/settings.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: SettingsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

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
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func has_(key: String) -> bool:
	assert(data)
	return key in data

func at_(key: String):
	assert(data)
	assert(key in data)
	return data[key]

func get_(key: String):
	assert(data)
	if key in data: return data[key]
	else: return null

func set_(key: String, value) -> void:
	assert(data)
	data[key] = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
