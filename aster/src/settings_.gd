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

func get_setting(key: String): return data[key]

func set_setting(key: String, value) -> void: data[key] = value

func has_setting(key: String) -> bool: return key in data

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_global(key: String): return ProjectSettings.get_setting(key)

func set_global(key: String, value) -> void: ProjectSettings.set_setting(key, value)

func has_global(key: String) -> bool: return ProjectSettings.has_setting(key)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func apply() -> void:
	DisplayServer.window_set_mode(get_setting("window_mode"))
	DisplayServer.window_set_size(get_setting("window_size"))
	DisplayServer.window_set_vsync_mode(get_setting("window_vsync"))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
