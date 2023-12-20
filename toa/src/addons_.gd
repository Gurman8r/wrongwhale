# addons_.gd
# Addons
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://addons"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: AddonsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	reset()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	var path_list: Array[String] = []
	DirAccess.make_dir_absolute(PATH)
	var dir = DirAccess.open(PATH)
	dir.list_dir_begin()
	var path: String = dir.get_next()
	while path != "":
		if path.get_extension() != "pck":
			path_list.append(path)
		path = dir.get_next()
	dir.list_dir_end()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_(key: String):
	assert(data)
	if not key in data: return null
	else: return data[key]

func set_(key: String, value) -> void:
	assert(data)
	data[key] = value

func has(key: String) -> bool:
	assert(data)
	return key in data

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
