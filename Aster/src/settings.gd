# settings.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const defaults: SettingsData = preload("res://assets/data/settings.tres")

@onready var data: SettingsData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	pass

func _ready() -> void:
	_reset()

func _reset() -> void:
	data = null
	data = SettingsData.read()
	if not data:
		data = defaults.duplicate()
		SettingsData.write(data)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
