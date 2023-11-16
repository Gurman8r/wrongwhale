# database.gd
class_name Database
extends Node

@export var data: DatabaseData

var dict: Dictionary = {}

func _init() -> void:
	assert(not Ref.database)
	Ref.database = self
	_refresh()

func _refresh() -> void:
	pass
