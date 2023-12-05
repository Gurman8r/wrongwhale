# settings.gd
class_name Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loaded()
signal saved()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: SettingsData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.settings)
	Ref.settings = self

func _reset() -> void:
	pass

func _ready() -> void:
	_reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
