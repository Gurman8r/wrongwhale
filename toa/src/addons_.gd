# addons_.gd
# Addons
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://addons"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var path_list: Array[String]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	print("")
	path_list = []
	DirAccess.make_dir_absolute(PATH)
	var dir = DirAccess.open(PATH)
	dir.list_dir_begin()
	var path: String = dir.get_next()
	while path != "":
		var extension = path.get_extension()
		if extension == "pck" \
		or extension == "zip":
			var full_path = "%s/%s" % [PATH, path]
			if ProjectSettings.load_resource_pack(full_path):
				print("addon: %s" % [full_path])
				path_list.append(full_path)
			else:
				printerr("invalid pack: %s" % [full_path])
		path = dir.get_next()
	dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
