# world.gd
class_name World
extends Node3D

signal loading(world_data: WorldData)
signal saving(world_data: WorldData)
signal loaded()
signal saved()

@export var data: WorldData

var cell: WorldCell : set = set_cell
var cells: Array[WorldCell]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world = self

func _ready():
	assert(0 < cells.size())
	cell = cells[0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_data(world_data: WorldData) -> void:
	if not world_data: return
	data = world_data.duplicate()
	loading.emit(data)
	loaded.emit()

func save_data() -> void:
	saving.emit(data)
	saved.emit()

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
