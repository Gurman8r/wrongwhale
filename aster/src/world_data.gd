# world_data.gd
class_name WorldData
extends Resource

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var guid: String
@export var name: String

@export var random_seed: String
@export var farm_data: FarmData = FarmData.new()
@export var object_data: Dictionary = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func manage(data: Resource) -> Resource:
	assert(data)
	assert("guid" in data)
	assert(not data.guid in object_data)
	object_data[data.guid] = data
	return data

func unmanage(key: String) -> void:
	assert(key in object_data)
	object_data.erase(key)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func read(path_stem: String) -> WorldData:
	return Util.read(get_file_path(path_stem))

static func write(world_data: WorldData, path_stem: String = "") -> Error:
	assert(world_data)
	if path_stem.is_empty(): path_stem = world_data.guid
	var dir_path = get_dir_path(path_stem)
	Util.wipe_dir(dir_path)
	DirAccess.make_dir_absolute(dir_path)
	return ResourceSaver.save(world_data, get_file_path(path_stem))

static func get_dir_path(path_stem: String) -> String:
	assert(0 < path_stem.length())
	return "%s/%s" % [World.SAVES_PATH, path_stem]

static func get_file_path(path_stem: String) -> String:
	assert(0 < path_stem.length())
	return "%s/%s/%s" % [World.SAVES_PATH, path_stem, World.FILE_NAME]

static func get_path_list() -> Array[String]:
	var path_list: Array[String] = []
	DirAccess.make_dir_absolute(World.SAVES_PATH)
	var saves_dir = DirAccess.open(World.SAVES_PATH)
	saves_dir.list_dir_begin()
	var path = saves_dir.get_next()
	while  path != "":
		if saves_dir.current_is_dir():
			var world_dir = DirAccess.open(get_dir_path(path))
			if not world_dir: continue
			world_dir.list_dir_begin()
			if world_dir.file_exists(World.FILE_NAME):
				path_list.append(path)
			world_dir.list_dir_end()
		path = saves_dir.get_next()
	saves_dir.list_dir_end()
	return path_list

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func make_test() -> WorldData:
	var w: WorldData = WorldData.new()
	w.guid = "Test"
	w.name = "Test"
	
	var f: FarmData = FarmData.new()
	f.name = "Test"
	w.farm_data = f
	
	var p: PlayerData = w.manage(PlayerData.new())
	p.guid = "Buster"
	p.name = "Buster"
	p.position = Vector3.ZERO
	p.direction = Vector3.FORWARD
	p.cell_name = "WorldCell0"
	p.inventory.resize(30)
	p.equip["0"].resize(1)
	
	return w

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
