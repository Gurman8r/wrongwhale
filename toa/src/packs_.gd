# packs_.gd
# Packs
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal pack_loaded(full_path: String)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PACKS_PATH := "user://packs"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var packs: Array[String] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute(PACKS_PATH)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	pack_loaded.connect(func(full_path: String):
		packs.append(full_path))
	
	# load packs
	assert(packs.is_empty())
	DirAccess.make_dir_absolute(PACKS_PATH)
	var dir = DirAccess.open(PACKS_PATH)
	if !dir: return
	dir.list_dir_begin()
	var path: String = dir.get_next()
	while path != "":
		var extension = path.get_extension()
		if extension == "pck" \
		or extension == "zip":
			var full_path = "%s/%s" % [PACKS_PATH, path]
			if packs.has(full_path): printerr("pack already loaded: %s" % [full_path])
			elif !ProjectSettings.load_resource_pack(full_path): printerr("failed loading pack: %s" % [full_path])
			else: pack_loaded.emit(full_path)
		path = dir.get_next()
	dir.list_dir_end()
	
	# display packs
	if !packs.is_empty(): print("")
	for p in packs: print("pack: %s" % [p])

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
