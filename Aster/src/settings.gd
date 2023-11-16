# settings.gd
class_name Settings
extends Node

signal loaded()
signal saved()

@export var data: SettingsData

func _init():
	assert(not Ref.settings)
	Ref.settings = self
