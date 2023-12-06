# config.gd
# Config
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const defaults: ConfigData = preload("res://assets/data/config.tres")

@onready var data: ConfigData = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	pass

func _ready() -> void:
	_reset()

func _reset() -> void:
	data = null
	data = ConfigData.read()
	if not data:
		data = defaults.duplicate()
		ConfigData.write(data)
	assert(data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
