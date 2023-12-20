# registry_.gd
# Registry
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/registry.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: RegistryData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	data = RegistryData.new()
	data.set_registry(Registries.REGISTRIES, {})
	_reset_items()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _reset_items() -> void:
	data.set_registry(Registries.ITEM, {})
	var items_path = "res://assets/items"
	var items_dir = DirAccess.open(items_path)
	items_dir.list_dir_begin()
	var path: String = items_dir.get_next()
	while path != "":
		if items_dir.current_is_dir() \
		or path.get_extension() != "tres": continue
		register(
			Registries.ITEM,
			path.get_slice(".", 0),
			ResourceLoader.load("%s/%s" % [items_path, path]))
		path = items_dir.get_next()
	items_dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func register(registry: int, key: String, value) -> bool:
	var dict = data.get_registry(registry)
	if key in dict: return false
	print("register: %s" % [key])
	dict[key] = value
	return true

func unregister(registry: int, key: String) -> bool:
	var dict = data.get_registry(registry)
	if not key in dict: return false
	print("unregister: %s" % [key])
	dict.erase(key)
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_(registry: int, key: String):
	assert(data)
	var dict = data.get_registry(registry)
	assert(dict.has(key))
	return dict[key]

func set_(registry: int, key: String, value) -> void:
	assert(data)
	var dict = data.get_registry(registry)
	dict[key] = value

func has(registry: int, key: String) -> bool:
	assert(data)
	return data.get_registry(registry).has(key)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func merge(registry_data: RegistryData) -> void:
	if registry_data == null \
	or registry_data == data: return
	for key in registry_data.registries:
		data.registries[key] = registry_data.registries[key]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
