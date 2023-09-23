# world.gd
class_name World
extends Node3D

signal world_loaded(world: World)
signal world_unloaded(world: World)

const player_prefab = preload("res://scenes/player.tscn")

@export var default_cell: WorldCell
var cell: WorldCell
var cells: Array[WorldCell]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.world = self

func _ready() -> void:
	for child in get_children():
		if child == default_cell:
			child.show()
		else:
			child.hide()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _on_visibility_changed():
	if visible:
		# load world here
		pass
	else:
		# unload world here
		pass
