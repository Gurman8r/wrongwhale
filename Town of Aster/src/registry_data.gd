# registry_data.gd
class_name RegistryData
extends Resource

signal registry_changed(registry: int)

@export var registries: Dictionary = {}

func get_registry(registry: int) -> Dictionary:
	var key = Registries.get_id(registry)
	match key:
		"REGISTRIES": return registries
		_: # default
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
		_:
			if registries.has(key) \
			and registries[key] == value: return
			registries[key] = value
			registry_changed.emit(registry)
