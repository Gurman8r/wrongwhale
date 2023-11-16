# save_data.gd
class_name WorldData
extends Resource

@export var guid: String = "Save_New"
@export var name: String = "New Save"

@export var actors: Dictionary = {}
@export var players: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func read(path_stem: String) -> Resource:
	var save_path: String = get_save_path(path_stem)
	if not ResourceLoader.exists(save_path): return null
	return ResourceLoader.load(save_path)

static func write(world_data: WorldData, path_stem: String) -> Error:
	return ResourceSaver.save(world_data, get_save_path(path_stem))

static func get_save_path(path_stem: String = "save0") -> String:
	assert(not path_stem.is_empty())
	return "user://%s.tres" % [path_stem]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
