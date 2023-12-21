# packs_.gd
# Packs
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal pack_loaded(full_path: String)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PACKS_PATH := "user://packs"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var packs: Dictionary

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute(PACKS_PATH)
	
	print("\nLOADING_PACKS")
	_load_all()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_all() -> void:
	packs = {}
	var dir = DirAccess.open(PACKS_PATH)
	if !dir: return
	dir.list_dir_begin()
	var path = dir.get_next()
	while path != "":
		match path.get_extension():
			"pck": _load_pck(path)
			"zip": _load_zip(path)
		path = dir.get_next()
	dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_pck(_path: String) -> bool:
	return false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_zip(path: String) -> bool:
	var full_path = "%s/%s" % [PACKS_PATH, path]
	var reader = ZIPReader.new()
	if reader.open(full_path) != OK: return false
	var file: PackedByteArray = reader.read_file("pack.cfg")
	if !file: return false
	var config: ConfigFile = ConfigFile.new()
	if config.parse(file.get_string_from_ascii()) != OK: return false
	var pack_name: String = config.get_value("pack", "name")
	if pack_name in packs: return false
	#if !ProjectSettings.load_resource_pack(full_path): return false
	print("++ %s" % [pack_name])
	packs[pack_name] = {
		"name": pack_name,
		"path": full_path,
	}
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
