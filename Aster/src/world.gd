# world.gd
class_name World
extends Node3D

signal loading(world_data: WorldData)
signal loading_started()
signal loading_finished()

signal saving(world_data: WorldData)
signal saving_started()
signal saving_finished()

signal unloading_started()
signal unloading()
signal unloading_finished()

const player_prefab = preload("res://assets/scenes/player.tscn")

@export var data: WorldData

var cell: WorldCell : set = change_cell
var cells: Array[WorldCell] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.world)
	Ref.world = self

func _ready():
	assert(cells.size() == get_child_count())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_data(world_data: WorldData) -> void:
	print("world loading")
	assert(world_data)
	loading_started.emit()
	data = world_data.duplicate()
	
	for guid in data.players:
		var player: Player = player_prefab.instantiate()
		if not Ref.player: Ref.player = player
		player.name = guid
		change_cell(find_cell(data.players[guid].cell_name))
		cell.add(player)
		print("player created: %s" % [player.name])
	
	for node in get_tree().get_nodes_in_group("rw"):
		loading.connect(node.load_data)
		saving.connect(node.save_data)
	
	loading.emit(data)
	show()
	loading_finished.emit()

func load_file(path_stem: String) -> void:
	print("world loading file: %s" % [path_stem])
	load_data(WorldData.read(path_stem))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save_data(world_data: WorldData) -> void:
	print("world saving")
	assert(world_data)
	saving_started.emit()
	saving.emit(world_data)
	saving_finished.emit()

func save_file(path_stem: String) -> void:
	print("world saving file: %s" % [path_stem])
	assert(not path_stem.is_empty())
	save_data(data)
	WorldData.write(data, path_stem)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func unload() -> void:
	print("world unloading: %s" % [name])
	unloading_started.emit()
	unloading.emit()
	
	for node in get_tree().get_nodes_in_group("rw"):
		loading.disconnect(node.load_data)
		saving.disconnect(node.save_data)
	
	for node in get_tree().get_nodes_in_group("player"):
		assert(node is Player)
		print("player destroyed: %s" % [node.name])
		if Ref.player == node: Ref.player = null
		node.queue_free()
	
	change_cell(null)
	data = null
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

func change_cell(value: WorldCell) -> void:
	if cell == value: return
	if cell: cell.disable()
	cell = value
	if cell: cell.enable()

func transfer(node: Node, target_cell: WorldCell, target_pos: Vector3 = Vector3.ZERO, transition: bool = true) -> void:
	assert(node)
	assert(target_cell)
	
	if transition:
		Ref.ui.transition.play("fadeout")
		await Ref.ui.transition.finished
	
	cell.remove(node)
	change_cell(target_cell)
	cell.add(node, target_pos)
	
	if "data" in node and "cell_name" in node.data:
		node.data.cell_name = cell.name
	
	if transition:
		Ref.ui.transition.play("fadein")
		await Ref.ui.transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
