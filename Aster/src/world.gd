# world.gd
class_name World
extends Node3D

signal loading_started()
signal loading(world_data: WorldData)
signal loading_finished()

signal saving_started()
signal saving(world_data: WorldData)
signal saving_finished()

signal unloading_started()
signal unloading()
signal unloading_finished()

signal player_created(player: Player)
signal player_destroyed(player: Player)

const player_prefab = preload("res://assets/scenes/player.tscn")

@export var data: WorldData = null

var cell: WorldCell : set = change_cell
var cells: Array[WorldCell] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.world)
	Ref.world = self

func _ready():
	assert(cells.size() == get_child_count())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_from_memory(world_data: WorldData) -> void:
	assert(world_data)
	print("LOADING WORLD: %s" % [world_data.guid])
	loading_started.emit()
	data = world_data.duplicate()
	
	# load players
	for guid in data.players:
		var player: Player = player_prefab.instantiate()
		player.name = guid
		change_cell(find_cell(data.players[guid].cell_name))
		cell.add(player)
	
	for node in get_tree().get_nodes_in_group("read"):
		assert("_read" in node)
		loading.connect(node._read)
	
	for node in get_tree().get_nodes_in_group("write"):
		assert("_write" in node)
		saving.connect(node._write)
	
	for node in get_tree().get_nodes_in_group("unload"):
		if "_unload" in node:
			unloading.connect(node._unload)
	
	loading.emit(data)
	show()
	loading_finished.emit()

func load_from_file(path_stem: String = "") -> void:
	if path_stem.is_empty() and data: path_stem = data.guid
	assert(0 < path_stem.length())
	load_from_memory(WorldData.read(path_stem))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save_to_memory(world_data: WorldData) -> void:
	assert(world_data)
	print("SAVING WORLD: %s" % [world_data.guid])
	saving_started.emit()
	saving.emit(world_data)
	saving_finished.emit()

func save_to_file(path_stem: String = "") -> void:
	if path_stem.is_empty() and data: path_stem = data.guid
	assert(0 < path_stem.length())
	print("SAVING WORLD: %s" % [path_stem])
	saving_started.emit()
	saving.emit(data)
	WorldData.write(data, path_stem)
	saving_finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func unload() -> void:
	assert(data)
	print("UNLOADING WORLD: %s" % [data.guid])
	unloading_started.emit()
	
	for node in get_tree().get_nodes_in_group("read"):
		assert("_read" in node)
		assert(loading.is_connected(node._read))
		loading.disconnect(node._read)
	
	for node in get_tree().get_nodes_in_group("write"):
		assert("_write" in node)
		assert(saving.is_connected(node._write))
		saving.disconnect(node._write)
	
	unloading.emit()
	for node in get_tree().get_nodes_in_group("unload"):
		if "_unload" in node:
			assert(unloading.is_connected(node._unload))
			unloading.disconnect(node._unload)
		node.queue_free()
	
	if cell: cell.disable()
	hide()
	cell = null
	data = null
	unloading_finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func change_cell(world_cell: WorldCell) -> void:
	if cell == world_cell: return
	if cell: cell.disable()
	cell = world_cell
	if cell: cell.enable()

func find_cell(cell_name: String) -> WorldCell:
	if has_node(cell_name): return get_node(cell_name) as WorldCell
	else: return null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

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
