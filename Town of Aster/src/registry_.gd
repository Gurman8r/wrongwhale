# registry_.gd
# Registry
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/registry.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: RegistryData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	data = Prefabs.DEFAULT_REGISTRY.duplicate()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func merge(registry_data: RegistryData) -> void:
	if registry_data == null \
	or registry_data == data:
		return
	for key in registry_data.registries:
		data.registries[key] = registry_data.registries[key]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func register(registry: int, key: String, value) -> bool:
	var dict = data.get_registry(registry)
	if key in dict: return false
	dict[key] = value.duplicate()
	return true

func unregister(registry: int, key: String) -> bool:
	var dict = data.get_registry(registry)
	if not key in dict: return false
	dict.erase(key)
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func has_(registry: int, key: String) -> bool:
	assert(data)
	var dict = data.get_registry(registry)
	return key in dict

func at_(registry: int, key: String):
	assert(data)
	var dict = data.get_registry(registry)
	assert(dict.has(key))
	return dict[key]

func get_(registry: int, key: String):
	assert(data)
	var dict = data.get_registry(registry)
	if not key in dict: return null
	return dict[key]

func set_(registry: int, key: String, value) -> void:
	assert(data)
	var dict = data.get_registry(registry)
	dict[key] = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
