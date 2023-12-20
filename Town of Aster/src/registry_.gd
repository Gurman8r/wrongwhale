# registry_.gd
# Registry
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/registry.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal registered(registry: int, key: String, value)
signal unregistered(registry: int, key: String)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: RegistryData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	registered.connect(func(registry: int, key: String, _value):
		Debug.puts("registered: %s %s" % [Registries.get_id(registry), key]))
	unregistered.connect(func(registry: int, key: String):
		Debug.puts("unregistered: %s %s" % [Registries.get_id(registry), key]))
	
	reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	data = RegistryData.new()
	set_registry(Registries.REGISTRIES, {})
	reset_items()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset_items() -> void:
	set_registry(Registries.ITEM, {})
	var dir_path = "res://assets/items"
	var dir = DirAccess.open(dir_path)
	if not dir: return
	dir.list_dir_begin()
	var path: String = dir.get_next()
	while path != "":
		if !dir.current_is_dir():
			path = path.trim_suffix(".remap")
			register(
				Registries.ITEM,
				path.get_slice(".", 0),
				ResourceLoader.load("%s/%s" % [dir_path, path]))
		path = dir.get_next()
	dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_registry(registry: int) -> Dictionary:
	assert(data)
	return data.get_registry(registry)

func set_registry(registry: int, value: Dictionary) -> void:
	assert(data)
	data.set_registry(registry, value)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func register(registry: int, key: String, value) -> bool:
	var dict = get_registry(registry)
	if dict.has(key): return false
	dict[key] = value
	registered.emit(registry, key, value)
	return true

func unregister(registry: int, key: String) -> bool:
	var dict = get_registry(registry)
	if not key in dict: return false
	dict.erase(key)
	unregistered.emit(registry, key)
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_(registry: int, key: String):
	var dict = get_registry(registry)
	assert(dict.has(key))
	return dict[key]

func set_(registry: int, key: String, value) -> void:
	var dict = get_registry(registry)
	dict[key] = value

func has(registry: int, key: String) -> bool:
	return get_registry(registry).has(key)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
