# world.gd
class_name World
extends Node3D
func _init(): Game.world = self

@export var default_cell: Cell
var cell: Cell
var cells: Array[Cell]

signal cell_registered(value: Cell)
signal cell_unregistered(value: Cell)
signal cell_changed(from: Cell, to: Cell)

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
	cell_changed.emit(value)
	return previous
