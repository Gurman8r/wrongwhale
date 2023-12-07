# registry.gd
# Registry
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/registry.tres"

@onready var data: RegistryData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	_reset()

func _reset() -> void:
	data = Util.read(PATH)
	if not data:
		data = preload("res://assets/data/registry.tres").duplicate()
		Util.write(data, PATH)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func register(registry: int, key: String, value: Resource) -> bool:
	var dict = data.get_dict(registry)
	if not value or key in dict: return false
	dict[key] = value
	return true

func unregister(registry: int, key: String) -> bool:
	var dict = data.get_dict(registry)
	if not key in dict: return false
	dict.erase(key)
	return true

func find(registry: int, key: String) -> Resource:
	var dict = data.get_dict(registry)
	if not key in dict: return null
	return dict[key]

func find_or_register(registry: int, key: String, value: Resource) -> Resource:
	var dict = data.get_dict(registry)
	if not key in dict: dict[key] = value
	return dict[key]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
