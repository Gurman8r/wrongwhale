# registries.gd
class_name Registries

#FIXME fabric registries

enum {
	REGISTRIES = -1,
	
	BLOCK,
	ITEM,
	BLOCK_ENTITY_TYPE,
	STATUS_EFFECT,
	PARTICLE_TYPE,
	FLUID,
	ENCHANTMENT,
	POTION,
	RECIPE_TYPE,
	RECIPE_SERIALIZER,
	SOUND_EVENT,
	STAT,
	CUSTOM_STAT,
	
	MAX
}

static func get_id(registry: int) -> String:
	if registry < 0 \
	or registry >= MAX:
		return "REGISTRIES"
	else:
		return [
			"BLOCK",
			"ITEM",
			"BLOCK_ENTITY_TYPE",
			"STATUS_EFFECT",
			"PARTICLE_TYPE",
			"FLUID",
			"ENCHANTMENT",
			"POTION",
			"RECIPE_TYPE",
			"RECIPE_SERIALIZER",
			"SOUND_EVENT",
			"STAT",
			"CUSTOM_STAT",
		][registry]
