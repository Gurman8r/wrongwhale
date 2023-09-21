# world.gd
class_name World
extends Node3D

@export var default_cell: WorldCell
var cell: WorldCell: set = goto_cell
var cells: Array[WorldCell]

signal cell_registered(value: WorldCell)
signal cell_unregistered(value: WorldCell)
signal active_cell_changed(from: WorldCell, to: WorldCell)

func _init():
	Game.world = self

func _ready():
	pass

func register_cell(value: WorldCell) -> bool:
	if cells.has(value): return false
	cells.append(value)
	cell_registered.emit(value)
	return true
	
func unregister_cell(value: WorldCell) -> bool:
	if !cells.has(value): return false
	cells.erase(value)
	cell_unregistered.emit(value)
	return true

func goto_cell(value: WorldCell) -> WorldCell:
	if cell == value: return null
	var previous: WorldCell = cell
	cell = value
	active_cell_changed.emit(previous, cell)
	return previous
