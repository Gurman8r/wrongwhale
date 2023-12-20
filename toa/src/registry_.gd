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
		print("registered: %s %s" % [Registries.get_id(registry), key]))
	unregistered.connect(func(registry: int, key: String):
		print("unregistered: %s %s" % [Registries.get_id(registry), key]))
	reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	data = RegistryData.new()
	set_registry(Registries.REGISTRIES, {})
	register_directory(Registries.ITEM, "res://assets/registry/item")

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

func register_directory(registry: int, dir_path: String) -> void:
	set_registry(registry, {})
	var dir = DirAccess.open(dir_path)
	if not dir: return
	dir.list_dir_begin()
	var path: String = dir.get_next()
	while path != "":
		if !dir.current_is_dir():
			if ".remap" in path: path = path.trim_suffix(".remap")
			var extension = path.get_extension()
			if extension != "tres": printerr("invalid extension: %s" % [extension])
			else:
				var full_path: String = "%s/%s" % [dir_path, path]
				if !ResourceLoader.exists(full_path): printerr("invalid resource: %s" % [full_path])
				else: register(registry, path.get_slice(".", 0), ResourceLoader.load(full_path))
		path = dir.get_next()
	dir.list_dir_end()

func unregister_directory(registry: int, dir_path: String) -> void:
	set_registry(registry, {})
	var dir = DirAccess.open(dir_path)
	if not dir: return
	dir.list_dir_begin()
	var path: String = dir.get_next()
	while path != "":
		if !dir.current_is_dir():
			if ".remap" in path: path = path.trim_suffix(".remap")
			var extension = path.get_extension()
			if extension != "tres": printerr("invalid extension: %s" % [extension])
			else: unregister(registry, path.get_slice(".", 0))
		path = dir.get_next()
	dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_(registry: int, key: String): return get_registry(registry)[key]

func set_(registry: int, key: String, value) -> void: get_registry(registry)[key] = value

func has_(registry: int, key: String) -> bool: return get_registry(registry).has(key)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
