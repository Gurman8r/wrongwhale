# world.gd
class_name World
extends Node3D

signal world_loaded(world: World)
signal world_unloaded(world: World)
signal cell_registered(world_cell: WorldCell)
signal cell_unregistered(world_cell: WorldCell)
signal cell_entered(world_cell: WorldCell)
signal cell_exited(world_cell: WorldCell)

const player_prefab = preload("res://scenes/player.tscn")

@export var default_cell: WorldCell
var cell: WorldCell: set = goto_cell
var cells: Array[WorldCell]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.world = self

func _ready() -> void:
	for child in get_children():
		if child == default_cell:
			child.show()
		else:
			child.hide()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _on_visibility_changed():
	if visible:
		# load world here
		world_loaded.emit(self)
	else:
		# unload world here
		world_unloaded.emit(self)
