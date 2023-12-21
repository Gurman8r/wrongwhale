# registry_.gd
# Registry
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal registry_changed(registry: int)
signal registered(registry: int, key: String, value)
signal unregistered(registry: int, key: String)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/registry.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var registries: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	print("\nREGISTRY")
	set_registry(Registries.REGISTRIES, {})
	register_directory(Registries.ITEM, "res://assets/registry/item")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_registry(registry: int) -> Dictionary:
	var key = Registries.get_id(registry)
	match key:
		"REGISTRIES": return registries
		_: # DEFAULT
			if !registries.has(key):
				registries[key] = {}
				registry_changed.emit(registry)
			return registries[key]

func set_registry(registry: int, value: Dictionary) -> void:
	var key = Registries.get_id(registry)
	match key:
		"REGISTRIES":
			if registries == value: return
			registries = value
			registry_changed.emit(registry)
		_: # DEFAULT
			if registries.has(key) \
			and registries[key] == value: return
			registries[key] = value
			registry_changed.emit(registry)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func register(registry: int, key: String, value) -> bool:
	var dict = get_registry(registry)
	if dict.has(key): return false
	dict[key] = value
	print("++ %s %s" % [Registries.get_id(registry), key])
	return true

func unregister(registry: int, key: String) -> bool:
	var dict = get_registry(registry)
	if not key in dict: return false
	dict.erase(key)
	print("-- %s %s" % [Registries.get_id(registry), key])
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
