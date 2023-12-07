# world.gd
class_name World
extends Node3D

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loading_started()
signal loading_finished()

signal saving_started()
signal saving_finished()

signal unloading_started()
signal unloading_finished()


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: WorldData = null

var cell: WorldCell = null : set = change_cell
var cells: Array[WorldCell] = []
var objects: Array[Node3D] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(Game.world == null)
	Game.world = self

func _ready():
	# cells should automatically add themselves to the list
	assert(cells.size() == get_child_count())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save_to_file(path_stem: String = "") -> void:
	if path_stem.is_empty():
		assert(data)
		path_stem = data.guid
	assert(0 < path_stem.length())
	saving_started.emit()
	WorldData.write(data, path_stem)
	saving_finished.emit()

func load_from_file(path_stem: String = "") -> void:
	if path_stem.is_empty() and data: path_stem = data.guid
	assert(0 < path_stem.length())
	load_from_memory(WorldData.read(path_stem))

func load_from_memory(world_data: WorldData) -> void:
	assert(world_data)
	loading_started.emit()
	data = world_data
	
	# create objects
	objects.clear()
	for guid in data.object_data:
		var d: Resource = data.object_data[guid]
		assert("prefab" in d)
		assert("cell_name" in d)
		assert("position" in d)
		
		var o: Node3D = d.prefab.instantiate()
		assert(o)
		o.data = d
		
		var c: WorldCell = find_cell(o.data.cell_name)
		assert(c)
		c.add(o, o.data.position)
		
		if o is PlayerCharacter:
			cell = c
			cell.enabled = true
		
		o.name = guid
		objects.append(o)
	
	show()
	loading_finished.emit()

func unload() -> void:
	assert(data)
	unloading_started.emit()
	
	# destroy objects
	for o in objects:
		o.queue_free()
	objects.clear()
	
	if cell: cell.enabled = false
	cell = null
	data = null
	
	hide()
	unloading_finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func find_cell(cell_name: String) -> WorldCell:
	if has_node(cell_name): return get_node(cell_name) as WorldCell
	else: return null

func change_cell(world_cell: WorldCell) -> void:
	if cell == world_cell: return
	if cell: cell.enabled = false
	cell = world_cell
	if cell: cell.enabled = true

func transfer(node: Node3D, world_cell: WorldCell, target_pos: Vector3 = Vector3.ZERO) -> void:
	assert(node)
	assert(world_cell)
	if cell: cell.remove(node)
	change_cell(world_cell)
	if cell: cell.add(node, target_pos)
	if "data" in node and "cell_name" in node.data:
		node.data.cell_name = cell.name

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
