# database.gd
class_name Database
extends Node

@export var data: DatabaseData

func _init() -> void:
	assert(not Ref.database)
	Ref.database = self
