# database.gd
class_name Database
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loading_started()
signal loading(database_data: DatabaseData)
signal loading_finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: DatabaseData

var dict: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.db)
	Ref.db = self

func _ready() -> void:
	_reset()

func _reset() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func find(_key: String) -> Object:
	return null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
