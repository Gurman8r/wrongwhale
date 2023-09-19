# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# world.gd
extends Node3D
class_name World

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@export var default_cell: Cell
var cell: Cell
var cells: Array[Cell]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

signal cell_entered(cell)
signal cell_exited(cell)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	print("World init")
	Game.world = self

func _ready():
	print("World ready")
	self.refresh_cells()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func refresh_cells():
	var to_remove = []
	self.cells.clear()
	for child in self.get_children():
		if child is Cell:
			self.cells.append(child)
		else:
			to_remove.append(child)
	assert(0 < self.cells.size(), "No cells were found")
	for child in to_remove:
		remove_child(child)
	if !self.default_cell:
		self.default_cell = self.cells[0]
	self.cell = self.default_cell

func set_cell(value: Cell) -> Cell:
	var previous: Cell = self.cell
	self.cell = value
	return previous

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
