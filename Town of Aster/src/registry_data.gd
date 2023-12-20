# registry_data.gd
class_name RegistryData
extends Resource

@export var registries: Dictionary

func get_registry(registry: int) -> Dictionary:
	var key = Registries.get_id(registry)
	match key:
		"REGISTRIES": return registries
		_: # default
			if !registries.has(key): registries[key] = {}
			return registries[key]

func set_registry(registry: int, value: Dictionary) -> void:
	var key = Registries.get_id(registry)
	match key:
		"REGISTRIES": registries = value
		_: registries[key] = value
