# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://settings.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: SettingsData

var config: ConfigFile

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	config = ConfigFile.new()
	config.load("user://settings.cfg")
	
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

func get_setting(key: String, default = null):
	if not key in data:
		data[key] = default
	return data[key]

func set_setting(key: String, value) -> void:
	data[key] = value

func has_setting(key: String) -> bool:
	return key in data

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func apply() -> void:
	DisplayServer.window_set_mode(get_setting("window_mode"))
	DisplayServer.window_set_size(get_setting("window_size"))
	DisplayServer.window_set_vsync_mode(get_setting("window_vsync"))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
