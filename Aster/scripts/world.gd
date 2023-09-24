# world.gd
class_name World
extends Node3D

@onready var cell_root: Node3D = $Cell
var cell: WorldCell
var cells: Array[WorldCell]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world = self

func _ready():
	assert(not cells.is_empty())
	cell = cells[0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func add_cell(value: WorldCell) -> bool:
	if (cells.has(value)): return false
	cells.append(value)
	if cell and cell.get_parent() != cell_root:
		cell.set_parent(cell_root)
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_visibility_changed():
	if visible:
		# load world here
		pass
	else:
		# unload world here
		pass
