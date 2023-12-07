# registry_data.gd
class_name RegistryData
extends Resource

@export var actors: Dictionary
@export var items: Dictionary
@export var misc: Dictionary

func get_dict(registry: int) -> Dictionary:
	match registry:
		Registries.ACTOR: return actors
		Registries.ITEM: return items
		_: return misc
