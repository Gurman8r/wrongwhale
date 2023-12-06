# world_data.gd
class_name WorldData
extends Resource

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const SAVES_PATH := "user://saves"
const FILE_NAME := "world.tres"

@export var guid: String
@export var name: String
@export var index: int
@export var world_seed: String
@export var farm_data: FarmData = FarmData.new()
@export var object_data: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func get_dir_path(path_stem: String) -> String:
	assert(0 < path_stem.length())
	return "%s/%s" % [SAVES_PATH, path_stem]

static func get_file_path(path_stem: String) -> String:
	assert(0 < path_stem.length())
	return "%s/%s/%s" % [SAVES_PATH, path_stem, FILE_NAME]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func read(path_stem: String) -> Resource:
	var file_path: String = get_file_path(path_stem)
	if not ResourceLoader.exists(file_path): return null
	return ResourceLoader.load(file_path)

static func write(world_data: WorldData, path_stem: String = "") -> Error:
	assert(world_data)
	if path_stem.is_empty(): path_stem = world_data.guid
	var dir_path = get_dir_path(path_stem)
	Util.wipe_dir(dir_path)
	DirAccess.make_dir_absolute(SAVES_PATH)
	DirAccess.make_dir_absolute(dir_path)
	return ResourceSaver.save(world_data, get_file_path(path_stem))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func exists(path_stem: String) -> bool:
	return ResourceLoader.exists(get_file_path(path_stem))

static func list() -> Array[String]:
	var path_list: Array[String] = []
	DirAccess.make_dir_absolute(SAVES_PATH)
	var saves_dir = DirAccess.open(SAVES_PATH)
	saves_dir.list_dir_begin()
	var path = saves_dir.get_next()
	while  path != "":
		if saves_dir.current_is_dir():
			var world_dir = DirAccess.open(get_dir_path(path))
			if not world_dir: continue
			world_dir.list_dir_begin()
			if world_dir.file_exists(FILE_NAME):
				path_list.append(path)
		path = saves_dir.get_next()
	return path_list

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
