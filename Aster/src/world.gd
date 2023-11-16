# world.gd
class_name World
extends Node3D

signal loading(world_data: WorldData)
signal loading_finished()

signal saving(world_data: WorldData)
signal saving_finished()

signal unloading()
signal unloading_finished()

const player_prefab = preload("res://assets/scenes/player.tscn")

@export var data: WorldData

var cell: WorldCell : set = set_cell
var cells: Array[WorldCell] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.world)
	Ref.world = self

func _ready():
	assert(0 < cells.size())
	cell = cells[0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_from_file(path_stem: String = "save0") -> void:
	var world_data: WorldData = WorldData.read(path_stem)
	assert(world_data)
	data = world_data.duplicate()
	loading.emit(data)
	show()
	loading_finished.emit()

func load_from_memory(world_data: WorldData) -> void:
	assert(world_data)
	data = world_data.duplicate()
	loading.emit(data)
	show()
	loading_finished.emit()

func save_to_file(path_stem: String = "save0") -> void:
	assert(not path_stem.is_empty())
	saving.emit(data)
	WorldData.write(data, path_stem)
	saving_finished.emit()

func save_to_memory(world_data: WorldData) -> void:
	assert(world_data)
	saving.emit(world_data)
	saving_finished.emit()

func unload() -> void:
	unloading.emit()
	hide()
	unloading_finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func find_cell(cell_name: String) -> WorldCell:
	if cell_name.is_empty():
		return null
	for world_cell in cells:
		if world_cell.name == cell_name:
			return world_cell
	return null

func set_cell(value: WorldCell) -> void:
	if cell == value: return
	if cell: cell.hide()
	cell = value
	if cell: cell.show()

func transfer(node: Node, target_cell: WorldCell, target_pos: Vector3 = Vector3.ZERO, transition: bool = true) -> void:
	assert(node)
	assert(target_cell)
	if transition:
		Ref.ui.transition.play("fadeout")
		await Ref.ui.transition.finished
	cell.remove(node)
	set_cell(target_cell)
	cell.add(node, target_pos)
	if "data" in node and "cell_name" in node.data:
		node.data.cell_name = cell.name
	if transition:
		Ref.ui.transition.play("fadein")
		await Ref.ui.transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
