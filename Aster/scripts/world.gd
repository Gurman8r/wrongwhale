# world.gd
class_name World
extends Node3D

@export var data: WorldData

var backup_data: WorldData
var cell: WorldCell : set = set_cell
var cells: Array[WorldCell]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world = self

func _ready():
	assert(0 < cells.size())
	cell = cells[0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_cell(world_cell: WorldCell):
	if cell == world_cell: return
	if cell: cell.hide()
	cell = world_cell
	if cell: cell.show()

func warp(node: Node3D, world_cell: WorldCell, location: Vector3 = Vector3.ZERO) -> void:
	Ref.ui.transition.play("fadeout")
	await Ref.ui.transition.finished
	cell.remove(node)
	set_cell(world_cell)
	cell.add(node, location)
	Ref.ui.transition.play("fadein")
	await Ref.ui.transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
