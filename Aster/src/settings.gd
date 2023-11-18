# settings.gd
class_name Settings
extends Node

signal loaded()
signal saved()

@export var data: SettingsData = null

func _init() -> void:
	assert(not Ref.settings)
	Ref.settings = self

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	pass
