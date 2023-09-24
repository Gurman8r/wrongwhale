# world.gd
class_name World
extends Node3D

var cell: WorldCell
var cells: Array[WorldCell]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world = self

func _ready():
	assert(not cells.is_empty())
	cell = cells[0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_visibility_changed():
	if visible:
		# load world here
		pass
	else:
		# unload world here
		pass
