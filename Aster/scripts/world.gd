# world.gd
class_name World
extends Node3D

signal loading(world_data: WorldData)
signal saving(world_data: WorldData)
signal unloading()
signal load_finished()
signal save_finished()
signal unload_finished()

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

func read_data(path_stem: String = "save0") -> void:
	load_data(WorldData.read(path_stem))

func load_data(world_data: WorldData) -> void:
	assert(world_data)
	data = world_data
	loading.emit(data)
	load_finished.emit()
	show()

func save_data(path_stem: String = "save0") -> void:
	assert(not path_stem.is_empty())
	saving.emit(data)
	WorldData.write(data, path_stem)
	save_finished.emit()

func unload():
	unloading.emit()
	unload_finished.emit()
	hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_cell(value: WorldCell) -> void:
	if cell == value: return
	if cell: cell.hide()
	cell = value
	if cell: cell.show()

func find_cell(cell_name: String) -> WorldCell:
	if cell_name.is_empty():
		return null
	for world_cell in cells:
		if world_cell.name == cell_name:
			return world_cell
	return null

func transfer(node: Node, target_cell: WorldCell, target_pos: Vector3 = Vector3.ZERO) -> void:
	assert(node)
	assert(target_cell)
	Ref.ui.transition.play("fadeout")
	await Ref.ui.transition.finished
	cell.remove(node)
	set_cell(target_cell)
	cell.add(node, target_pos)
	Ref.ui.transition.play("fadein")
	await Ref.ui.transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
