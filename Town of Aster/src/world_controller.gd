# world_controller.gd
# World
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loading_started()
signal loading_finished()

signal saving_started()
signal saving_finished()

signal unloading_started()
signal unloading_finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var data: WorldData

var world_environment: WorldEnvironment

var cell_root: Node
var cell: WorldCell = null : set = change_cell
var cells: Array[WorldCell] = []
var objects: Array[Node3D] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	reset_environment()
	reset_cells()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_environment() -> Environment:
	return world_environment.environment

func set_environment(value: Environment) -> void:
	world_environment.environment = value

func reset_environment() -> void:
	if world_environment == null:
		world_environment = Utility.make_child(self, WorldEnvironment.new(), "Environment")
	world_environment.environment = preload("res://assets/data/environment.tres").duplicate()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_cell() -> WorldCell:
	return cell

func change_cell(new_cell: WorldCell) -> void:
	if cell == new_cell: return
	if cell: cell.enabled = false
	cell = new_cell
	if cell: cell.enabled = true

func find_cell(cell_name: String) -> WorldCell:
	if cell_root.has_node(cell_name):
		return cell_root.get_node(cell_name)
	else:
		return null

func transfer(node: Node3D, new_cell: WorldCell, position: Vector3 = Vector3.ZERO) -> void:
	assert(node)
	assert(new_cell)
	if cell: cell.remove(node)
	change_cell(new_cell)
	if cell: cell.add(node, position)
	if "data" in node and "cell_name" in node.data:
		node.data.cell_name = cell.name

func reset_cells() -> void:
	cell_root = Utility.make_child(self, preload("res://assets/scenes/world_cells.tscn").instantiate(), "Cells")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save(path_stem: String = "") -> void:
	if path_stem.is_empty():
		assert(data)
		path_stem = data.guid
	assert(0 < path_stem.length())
	saving_started.emit()
	WorldData.write(data, path_stem)
	saving_finished.emit()

func reload() -> void:
	assert(data)
	loading_started.emit()
	
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
	
	loading_finished.emit()

func unload() -> void:
	assert(data)
	unloading_started.emit()
	
	for o in objects:
		o.queue_free()
	objects.clear()
	
	if cell:
		cell.enabled = false
		cell = null
	data = null
	
	unloading_finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
