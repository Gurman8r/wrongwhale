# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://settings.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: SettingsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	reset()
	apply()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	read()
	if !data: data = Prefabs.DEFAULT_SETTINGS.duplicate()
	assert(data)
	write()

func read() -> void:
	data = Util.read(PATH)

func write() -> void:
	Util.write(data, PATH)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_setting(key: String):
	assert(data)
	assert(key in data)
	return data[key]

func set_setting(key: String, value) -> void:
	assert(data)
	data[key] = value

func has_setting(key: String) -> bool:
	assert(data)
	return key in data

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func apply() -> void:
	DisplayServer.window_set_mode(get_setting("window_mode"))
	DisplayServer.window_set_size(get_setting("window_size"))
	DisplayServer.window_set_vsync_mode(get_setting("window_vsync"))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
