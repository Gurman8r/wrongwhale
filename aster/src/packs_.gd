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
	packs = {}
	_load_packs()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_packs() -> void:
	assert(packs == {})
	var dir = DirAccess.open(PACKS_PATH)
	if !dir: return
	dir.list_dir_begin()
	var path = dir.get_next()
	while path != "":
		var full_path = "%s/%s" % [PACKS_PATH, path]
		match full_path.get_extension():
			"pck": _load_pck(full_path)
			"zip": _load_zip(full_path)
		path = dir.get_next()
	dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region ZIP

func _load_zip(full_path: String) -> bool:
	var config: ConfigFile = _load_zip_config(full_path)
	if !config: return false
	var pack_guid: String = config.get_value("pack", "guid", "")
	if pack_guid == "" \
	or pack_guid in packs: return false
	#if !ProjectSettings.load_resource_pack(full_path): return false
	packs[pack_guid] = {
		"path": full_path,
		"guid": pack_guid,
		"name": config.get_value("pack", "name", pack_guid),
		"deps": config.get_value("pack", "deps", []),
		"icon": config.get_value("pack", "icon", ""),
		"banner": config.get_value("pack", "banner", ""),
		"background": config.get_value("pack", "background", ""),
	}
	print("++ %s" % [packs[pack_guid].name])
	return true

func _load_zip_config(full_path: String) -> ConfigFile:
	var reader = ZIPReader.new()
	if reader.open(full_path) != OK: return null
	var file: PackedByteArray = reader.read_file("pack.cfg")
	if !file: return null
	var config: ConfigFile = ConfigFile.new()
	if config.parse(file.get_string_from_ascii()) != OK: return null
	return config

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region PCK

func _load_pck(_full_path: String) -> bool:
	return false

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
