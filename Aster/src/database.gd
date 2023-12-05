# database.gd
class_name Database
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: DatabaseData

var dict: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.database)
	Ref.database = self

func _reset() -> void:
	pass

func _ready() -> void:
	_reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func find(_key: String) -> Object:
	return null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
