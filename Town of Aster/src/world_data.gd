# world_data.gd
class_name WorldData
extends Resource

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var guid: String
@export var name: String
@export var index: int

@export var world_seed: String
@export var object_data: Dictionary = {}
@export var farm_data: FarmData = FarmData.new()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func add_object_data(new_data: Resource) -> Resource:
	assert(new_data)
	assert("guid" in new_data)
	object_data[new_data.guid] = new_data
	return new_data

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const DIR := "user://saves"
const FILE := "world.tres"

static func read(path_stem: String) -> WorldData:
	return Util.read(get_file_path(path_stem))

static func write(world_data: WorldData, path_stem: String = "") -> Error:
	assert(world_data)
	if path_stem.is_empty(): path_stem = world_data.guid
	var dir_path = get_dir_path(path_stem)
	Util.wipe(dir_path)
	DirAccess.make_dir_absolute(dir_path)
	return ResourceSaver.save(world_data, get_file_path(path_stem))

static func get_dir_path(path_stem: String) -> String:
	assert(0 < path_stem.length())
	return "%s/%s" % [DIR, path_stem]

static func get_file_path(path_stem: String) -> String:
	assert(0 < path_stem.length())
	return "%s/%s/%s" % [DIR, path_stem, FILE]

static func get_path_list() -> Array[String]:
	var path_list: Array[String] = []
	DirAccess.make_dir_absolute(DIR)
	var saves_dir = DirAccess.open(DIR)
	saves_dir.list_dir_begin()
	var path = saves_dir.get_next()
	while  path != "":
		if saves_dir.current_is_dir():
			var world_dir = DirAccess.open(get_dir_path(path))
			if not world_dir: continue
			world_dir.list_dir_begin()
			if world_dir.file_exists(FILE):
				path_list.append(path)
		path = saves_dir.get_next()
	return path_list

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func make_test() -> WorldData:
	var f: FarmData = FarmData.new()
	f.name = "Test"
	
	var p: PlayerData = PlayerData.new()
	p.guid = "Buster"
	p.name = "Buster"
	p.position = Vector3.ZERO
	p.direction = Vector3.FORWARD
	p.cell_name = "WorldCell0"
	p.inventory_data.resize(30)
	p.equip_data.resize(1)
	
	var w: WorldData = WorldData.new()
	w.guid = "Test"
	w.name = "Test"
	w.farm_data = f
	w.object_data[p.guid] = p
	return w

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
