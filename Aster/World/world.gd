# world.gd
class_name World
extends Node3D

@export var default_cell: Cell
var cell: Cell
var cells: Array[Cell]

signal cell_registered(value: Cell)
signal cell_unregistered(value: Cell)
signal active_cell_changed(from: Cell, to: Cell)

func _init():
	assert(Global.world == null)
	Global.world = self

func register_cell(value: Cell) -> bool:
	if cells.has(value): return false
	cells.append(value)
	cell_registered.emit(value)
	return true
	
func unregister_cell(value: Cell) -> bool:
	if !cells.has(value): return false
	cells.erase(value)
	cell_unregistered.emit(value)
	return true

func set_active_cell(value: Cell) -> Cell:
	if cell == value: return null
	var previous: Cell = cell
	cell = value
	active_cell_changed.emit(previous, cell)
	return previous
