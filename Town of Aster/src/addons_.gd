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
	var addons_dir = DirAccess.open(PATH)
	addons_dir.list_dir_begin()
	var path: String = addons_dir.get_next()
	while path != "":
		if addons_dir.current_is_dir() \
		or path.get_extension() != "pck": continue
		path_list.append(path)
		path = addons_dir.get_next()
	addons_dir.list_dir_end()

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
