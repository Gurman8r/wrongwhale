# world.gd
class_name World
extends Node3D

var cell: WorldCell : set = set_cell
var cells: Array[WorldCell]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world = self

func _ready():
	assert(not cells.is_empty())
	cell = cells[0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_cell(value: WorldCell):
	if cell == value: return
	if cell: cell.hide()
	cell = value
	if cell: cell.show()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_visibility_changed():
	if visible:
		# load world here
		pass
	else:
		# unload world here
		pass
