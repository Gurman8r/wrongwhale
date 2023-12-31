# content_.gd
# Content
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal pack_loaded(full_path: String)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PACKS_PATH := "user://packs"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var pack_info: Dictionary
var pack_deps: Dictionary

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute(PACKS_PATH)
	
	print("\nLOADING_PACKS")
	_load_pack_info()
	_load_pack_deps()
	_load_pack_data()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_pack_config(full_path: String) -> ConfigFile:
	match full_path.get_extension():
		"pck": return _load_pck_config(full_path)
		"zip": return _load_zip_config(full_path)
		_: return null

func _load_zip_config(full_path: String) -> ConfigFile:
	var reader = ZIPReader.new()
	if reader.open(full_path) != OK: return null
	var file: PackedByteArray = reader.read_file("pack.cfg")
	if !file: return null
	var config: ConfigFile = ConfigFile.new()
	if config.parse(file.get_string_from_ascii()) != OK: return null
	return config

func _load_pck_config(_full_path: String) -> ConfigFile:
	return null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_pack_info() -> void:
	pack_info = {}
	var dir = DirAccess.open(PACKS_PATH)
	if !dir: return
	dir.list_dir_begin()
	var path = dir.get_next()
	while path != "":
		var full_path = "%s/%s" % [PACKS_PATH, path]
		var config = _load_pack_config(full_path)
		if config:
			var pack_guid: String = config.get_value("pack", "guid", "")
			if pack_guid != "" and not pack_guid in pack_info:
				pack_info[pack_guid] = {
					"path":        full_path,
					"guid":        pack_guid,
					"name":        config.get_value("pack", "name", pack_guid),
					"version":     config.get_value("pack", "version", "0.0.0.0"),
					"deps":        config.get_value("pack", "deps", []),
					"tagline":     config.get_value("pack", "tagline", ""),
					"description": config.get_value("pack", "description", ""),
					"icon":        config.get_value("pack", "icon", ""),
					"banner":      config.get_value("pack", "banner", ""),
					"background":  config.get_value("pack", "background", ""),
				}
				print("++ %s" % [pack_info[pack_guid].name])
		path = dir.get_next()
	dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_pack_deps() -> void:
	pack_deps = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_pack_data() -> void:
	#if !ProjectSettings.load_resource_pack(full_path): return false
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
