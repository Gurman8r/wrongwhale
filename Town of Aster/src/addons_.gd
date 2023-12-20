# addons_.gd
# Addons
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: AddonsData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _ready() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
