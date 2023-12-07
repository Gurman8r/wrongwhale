# registry_data.gd
class_name RegistryData
extends Resource

@export var registries: Dictionary

@export var actors: Dictionary
@export var items: Dictionary
@export var misc: Dictionary

func get_dict(registry: int) -> Dictionary:
	match registry:
		Registries.REGISTRIES: return registries
		_:
			var key = "%d" % [registry]
			if not key in registries:
				registries[key] = Dictionary()
			return registries[key]
