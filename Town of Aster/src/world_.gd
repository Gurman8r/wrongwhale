# world_.gd
# World
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loading_started()
signal loading_finished()

signal saving_started()
signal saving_finished()

signal unloading_started()
signal unloading_finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _ready() -> void:
	reset_environment()
	reset_cells()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region DATA

@export var data: WorldData

func save(path_stem: String = "") -> void:
	if path_stem.is_empty() and data: path_stem = data.guid
	assert(0 < path_stem.length())
	saving_started.emit()
	WorldData.write(data, path_stem)
	saving_finished.emit()

func reload() -> void:
	assert(data)
	loading_started.emit()
	
	objects = []
	for guid in data.object_data:
		create_from_data(data.object_data[guid])
	
	loading_finished.emit()

func unload() -> void:
	assert(data)
	unloading_started.emit()
	
	for o in objects: o.queue_free()
	objects = []
	
	if _cell: _cell.enabled = false
	_cell = null
	data = null
	
	unloading_finished.emit()

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region CELLS

var _cell: WorldCell # current cell
var cell: WorldCell : get = get_cell, set = change_cell
var cells: Array[WorldCell]
var cell_root: Node

func get_cell() -> WorldCell: return _cell

func change_cell(new_cell: WorldCell) -> void:
	if _cell == new_cell: return
	if _cell:
		Debug.puts("%s" % [""])
		_cell.enabled = false
	_cell = new_cell
	if _cell:
		_cell.enabled = true

func find_cell(cell_name: String) -> WorldCell:
	if cell_root.has_node(cell_name): return cell_root.get_node(cell_name)
	else: return null

func transfer(node: Node3D, new_cell: WorldCell, position: Vector3 = Vector3.ZERO) -> void:
	assert(node)
	assert(new_cell)
	if _cell: _cell.remove(node)
	change_cell(new_cell)
	if _cell: _cell.add(node, position)
	if "data" in node and "cell_name" in node.data:
		node.data.cell_name = _cell.name

func reset_cells() -> void:
	cell_root = Util.make(self, Prefabs.WORLD_CELLS.instantiate(), "WorldCells")
	cell_root.process_mode = PROCESS_MODE_PAUSABLE

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region OBJECTS

var objects: Array[Node3D]

func create_from_data(d: Resource) -> Node3D:
	assert("PREFAB" in d)
	assert("cell_name" in d)
	assert("position" in d)
	var o: Node3D = d.PREFAB.instantiate()
	assert(o)
	o.data = d
	var c: WorldCell = find_cell(o.data.cell_name)
	assert(c)
	c.add(o, o.data.position)
	if o is PlayerCharacter:
		_cell = c
		_cell.enabled = true
	o.name = d.guid
	objects.append(o)
	return o

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region ENVIRONMENT

var _world_environment: WorldEnvironment

var environment: Environment : get = get_environment, set = set_environment

func get_environment() -> Environment: return _world_environment.environment

func set_environment(value: Environment) -> void: if _world_environment.environment != value: _world_environment.environment = value

func reset_environment() -> void:
	if !_world_environment: _world_environment = Util.make(self, WorldEnvironment.new(), "WorldEnvironment")
	_world_environment.environment = Prefabs.DEFAULT_ENVIRONMENT.duplicate()

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
