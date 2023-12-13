# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/settings.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var data: SettingsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _ready() -> void:
	reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	data = Util.read(PATH)
	if not data:
		load_defaults()
		#save_to_file()
	assert(data)

func load_defaults() -> void:
	data = preload("res://assets/data/default_settings.tres").duplicate()

func load_from_file() -> void:
	data = Util.read(PATH)

func save_to_file() -> void:
	Util.write(data, PATH)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
