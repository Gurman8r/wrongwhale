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

@export var data: WorldData

var cells: Array[WorldCell] = []
var current_cell: WorldCell : set = change_cell

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(not Ref.world)
	Ref.world = self

func _ready():
	assert(cells.size() == get_child_count())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_data(world_data: WorldData) -> void:
	print("LOADING WORLD: %s" % [world_data.guid])
	assert(world_data)
	loading_started.emit()
	data = world_data.duplicate()
	
	# load players
	for guid in data.players:
		var player: Player = player_prefab.instantiate()
		player.name = guid
		change_cell(get_cell(data.players[guid].cell_name))
		current_cell.add(player)
	
	# setup read/write
	for node in get_tree().get_nodes_in_group("rw"):
		assert("_load_data" in node)
		assert("_save_data" in node)
		loading.connect(node._load_data)
		saving.connect(node._save_data)
	
	loading.emit(data)
	show()
	loading_finished.emit()

func load_from_file(path_stem: String) -> void:
	assert(0 < path_stem.length())
	load_data(WorldData.read(path_stem))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save_data(world_data: WorldData) -> void:
	print("SAVING WORLD: %s" % [world_data.guid])
	assert(world_data)
	saving_started.emit()
	saving.emit(world_data)
	saving_finished.emit()

func save_to_file(path_stem: String) -> void:
	assert(0 < path_stem.length())
	save_data(data)
	WorldData.write(data, path_stem)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func unload() -> void:
	print("UNLOADING WORLD: %s" % [data.guid])
	unloading_started.emit()
	unloading.emit()
	
	# cleanup read/write
	for node in get_tree().get_nodes_in_group("rw"):
		assert("_load_data" in node)
		assert("_save_data" in node)
		loading.disconnect(node._load_data)
		saving.disconnect(node._save_data)
	
	change_cell(null)
	data = null
	hide()
	unloading_finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func change_cell(value: WorldCell) -> void:
	if current_cell == value: return
	if current_cell: current_cell.disable()
	current_cell = value
	if current_cell: current_cell.enable()

func get_cell(cell_name: String) -> WorldCell:
	if has_node(cell_name): return get_node(cell_name) as WorldCell
	else: return null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func transfer(node: Node, target_cell: WorldCell, target_pos: Vector3 = Vector3.ZERO, transition: bool = true) -> void:
	assert(node)
	assert(target_cell)
	
	if transition:
		Ref.ui.transition.play("fadeout")
		await Ref.ui.transition.finished
	
	current_cell.remove(node)
	change_cell(target_cell)
	current_cell.add(node, target_pos)
	
	if "data" in node and "cell_name" in node.data:
		node.data.cell_name = current_cell.name
	
	if transition:
		Ref.ui.transition.play("fadein")
		await Ref.ui.transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
