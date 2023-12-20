# addons_.gd
# Addons
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: AddonsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func has(key: String) -> bool:
	assert(data)
	return key in data

func get_(key: String):
	assert(data)
	assert(key in data)
	return data[key]

func set_(key: String, value) -> void:
	assert(data)
	data[key] = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
