# registry.gd
# Registry
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/registry.tres"

var data: RegistryData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	reset()

func reset() -> void:
	load_defaults()
	save_to_file()

func load_defaults() -> void:
	data = preload("res://assets/data/registry.tres").duplicate()

func load_from_file() -> void:
	data = Utility.read(PATH)

func save_to_file() -> void:
	Utility.write(data, PATH)

func merge(registry_data: RegistryData) -> void:
	if registry_data == null \
	or registry_data == data:
		return
	for key in registry_data.registries:
		data.registries[key] = registry_data.registries[key]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func register(registry: int, key: String, value: Resource) -> bool:
	var dict = data.get_dict(registry)
	if key in dict: return false
	dict[key] = value.duplicate()
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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
