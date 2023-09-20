# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# world.gd
class_name World
extends Node3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var _cell: Node3D = $Cell
@export var default_cell: Cell
var cell: Cell
var cells: Array[Cell]

signal cell_changed(from: Cell, to: Cell)
signal cell_registered(value: Cell)
signal cell_unregistered(value: Cell)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	Game.world = self

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func register_cell(value: Cell) -> bool:
	if self.cells.has(value): return false
	self.cells.append(value)
	self.cell_registered.emit(value)
	print("Registered Cell: "+value.data.name)
	return true
	
func unregister_cell(value: Cell) -> bool:
	if !self.cells.has(value): return false
	self.cells.erase(value)
	self.cell_unregistered.emit(value)
	print("Unregistered Cell: "+value.data.name)
	return true

func set_cell(value: Cell) -> Cell:
	if self.cell == value: return null
	var previous: Cell = self.cell
	self.cell = value
	self.cell_changed.emit(previous, value)
	return previous

func warp_player(player: Player, destination: Cell, location: Vector3 = Vector3()) -> void:
	if self.cell != destination:
		set_cell(destination)
	player.position = location;

func refresh_cells():
	var to_remove = []
	self.cells.clear()
	for child in _cell.get_children():
		if child is Cell: self.cells.append(child)
		else: to_remove.append(child)
	assert(0 < self.cells.size(), "No cells were found")
	for child in to_remove:
		_cell.remove_child(child)
	if !self.default_cell:
		self.default_cell = self.cells[0]
	self.cell = self.default_cell

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
