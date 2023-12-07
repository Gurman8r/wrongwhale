# settings.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/settings.tres"

@onready var data: SettingsData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	_reset()

func _reset() -> void:
	data = Util.read(PATH)
	if not data:
		data = preload("res://assets/data/settings.tres").duplicate()
		Util.write(data, PATH)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
