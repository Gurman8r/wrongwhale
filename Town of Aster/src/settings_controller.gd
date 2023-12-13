# settings_controller.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/settings.tres"

var data: SettingsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	reset()

func reset() -> void:
	data = Utility.read(PATH)
	if not data:
		load_defaults()
		save_to_file()
	assert(data)

func load_defaults() -> void:
	data = preload("res://assets/data/settings.tres").duplicate()

func load_from_file() -> void:
	data = Utility.read(PATH)

func save_to_file() -> void:
	Utility.write(data, PATH)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
