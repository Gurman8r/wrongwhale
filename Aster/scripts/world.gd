# world.gd
class_name World
extends Node3D

@export var default_cell: WorldCell
var cell: WorldCell: set = goto_cell
var cells: Array[WorldCell]

signal cell_registered(value: WorldCell)
signal cell_unregistered(value: WorldCell)
signal cell_entered(value: WorldCell)
signal cell_exited(value: WorldCell)

func _init() -> void:
	Game.world = self

func _ready() -> void:
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
	cell_exited.emit(cell)
	cell = value
	cell_entered.emit(cell)
	return previous
