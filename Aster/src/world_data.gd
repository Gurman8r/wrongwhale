# world_data.gd
class_name WorldData
extends Resource

const SAVES_PATH := "user://saves"

@export var guid: String = "World_New"
@export var name: String = "New World"
@export var index: int = 0

@export var actors: Dictionary = {}
@export var players: Dictionary = {}
@export var objects: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func read(path_stem: String) -> Resource:
	assert(0 < path_stem.length())
	var save_path: String = "%s/%s/world.tres" % [SAVES_PATH, path_stem]
	if not ResourceLoader.exists(save_path): return null
	return ResourceLoader.load(save_path)

static func write(world_data: WorldData, path_stem: String) -> Error:
	assert(world_data)
	assert(0 < path_stem.length())
	DirAccess.remove_absolute("%s/%s" % [SAVES_PATH, path_stem])
	DirAccess.make_dir_absolute("%s" % [SAVES_PATH])
	DirAccess.make_dir_absolute("%s/%s" % [SAVES_PATH, path_stem])
	return ResourceSaver.save(world_data, "%s/%s/world.tres" % [SAVES_PATH, path_stem])

static func list(path_list: Array[String]) -> int:
	if not path_list: return -2
	var saves_dir = DirAccess.open("%s" % [SAVES_PATH])
	if not saves_dir: return -1
	saves_dir.list_dir_begin()
	var path = saves_dir.get_next()
	while  path != "":
		if saves_dir.current_is_dir():
			var world_dir = DirAccess.open("%s/%s" % [SAVES_PATH, path])
			if not world_dir: continue
			world_dir.list_dir_begin()
			if world_dir.file_exists("world.tres"):
				path_list.append(path)
		path = saves_dir.get_next()
	return path_list.size()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
