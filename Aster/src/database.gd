# database.gd
# Database
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loading_started()
signal loading(database_data: DatabaseData)
signal loading_finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var data: DatabaseData = null

var dict: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	_reset()

func _reset() -> void:
	data = null
	data = DatabaseData.read()
	if not data:
		data = preload("res://assets/data/database.tres").duplicate()
		DatabaseData.write(data)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func lookup(_key: String) -> Object:
	return null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
