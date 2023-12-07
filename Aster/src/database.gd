# database.gd
# Database
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var data: DatabaseData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	_reset()
	print("Database - OK")

func _reset() -> void:
	data = null
	data = DatabaseData.read()
	if not data:
		data = preload("res://assets/data/database.tres").duplicate()
		DatabaseData.write(data)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func find(key: String) -> Resource:
	if key in data.dict:
		return data.dict[key]
	else:
		return null

func insert(key: String, value: Resource) -> bool:
	if not value or key in data.dict:
		return false
	else:
		data.dict[key] = value
		return true

func find_or_add(key: String, value: Resource) -> Resource:
	if not key in data.dict:
		data.dict[key] = value
	return data.dict[key]

func erase(key: String) -> bool:
	if not key in data.dict:
		return false
	else:
		data.dict.erase(key)
		return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
