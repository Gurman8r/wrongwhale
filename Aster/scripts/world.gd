# world.gd
class_name World
extends Node3D

signal world_loaded(world: World)
signal world_unloaded(world: World)

@export var default_cell: WorldCell

var cell: WorldCell
var cells: Array[WorldCell]

func _init() -> void:
	Ref.world = self

func _ready() -> void:
	for child in get_children():
		child.visible = child == default_cell

func _on_visibility_changed():
	if visible:
		# load world here
		pass
	else:
		# unload world here
		pass
