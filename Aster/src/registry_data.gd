# registry_data.gd
class_name RegistryData
extends Resource

@export var registries: Dictionary

func get_dict(registry: int) -> Dictionary:
	match registry:
		Registries.REGISTRIES: return registries
		_:
			assert(registry != Registries.MAX)
			var key = "%d" % [registry]
			if not key in registries:
				registries[key] = Dictionary()
			return registries[key]