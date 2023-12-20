# addons_.gd
# Addons
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const MODS_PATH := "user://mods"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var mods: Array[String] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	_load_mods()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _load_mods() -> void:
	assert(mods == [])
	DirAccess.make_dir_absolute(MODS_PATH)
	var dir = DirAccess.open(MODS_PATH)
	if !dir: return
	dir.list_dir_begin()
	var path: String = dir.get_next()
	while path != "":
		var extension = path.get_extension()
		if extension == "pck" \
		or extension == "zip":
			var full_path = "%s/%s" % [MODS_PATH, path]
			if ProjectSettings.load_resource_pack(full_path):
				mods.append(full_path)
			else:
				printerr("invalid modpack: %s" % [full_path])
		path = dir.get_next()
	dir.list_dir_end()
	if !mods.is_empty(): print("")
	for p in mods: print("modpack: %s" % [p])

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
