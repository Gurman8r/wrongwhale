# settings.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var data: SettingsData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	_reset()

func _reset() -> void:
	data = SettingsData.read()
	if not data:
		data = preload("res://assets/data/settings.tres").duplicate()
		SettingsData.write(data)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
