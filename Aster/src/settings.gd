# settings.gd
class_name Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loading_started()
signal loading(settings_data: SettingsData)
signal loading_finished()

signal saving_started()
signal saving(settings_data: SettingsData)
signal saving_finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: SettingsData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.cfg)
	Ref.cfg = self

func _ready() -> void:
	_reset()

func _reset() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
