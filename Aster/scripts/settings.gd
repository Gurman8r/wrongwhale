# settings.gd
class_name Settings
extends Node

signal loaded()
signal saved()

func _init():
	Ref.settings = self

func read_settings():
	pass
	
func write_settings():
	pass
