# world_.gd
# World
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const SAVES_PATH := "user://saves"
const FILE_NAME := "world.tres"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal loading_started()
signal loading_finished()

signal saving_started()
signal saving_finished()

signal unloading_started()
signal unloading_finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: WorldData

var _environment: WorldEnvironment
var environment: Environment : get = get_environment, set = set_environment

var _cell: WorldCell # current cell
var cell: WorldCell : get = get_cell, set = change_cell
var cells: Array[WorldCell]
var cell_root: Node
var objects: Array[Node3D]

var _is_playing: bool = false
var _is_opening: bool = false
var _is_closing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_absolute(SAVES_PATH)
	
	_environment = Util.make(self, WorldEnvironment.new(), "Environment")
	_environment.environment = Prefabs.DEFAULT_ENVIRONMENT.duplicate()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	cell_root = Util.make(self, Prefabs.WORLD_CELLS.instantiate(), "Cells")
	cell_root.process_mode = Node.PROCESS_MODE_PAUSABLE

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func open() -> bool:
	if !data: return false
	if _is_playing or _is_opening or _is_closing: return false
	_is_opening = true
	seed(data.random_seed.hash())
	loading_started.emit()
	
	objects = []
	for guid in data.object_data:
		var d = data.object_data[guid]
		assert("PREFAB" in d)
		assert("cell_name" in d)
		assert("position" in d)
		var o: Node3D = d.PREFAB.instantiate()
		assert(o)
		o.data = d
		var c: WorldCell = find_cell(o.data.cell_name)
		assert(c)
		c.add(o, o.data.position)
		o.name = d.guid
		if o is PlayerCharacter:
			_cell = c
			_cell.enabled = true
			print(">| %s" % [_cell.name])
		objects.append(o)
	
	loading_finished.emit()
	_is_opening = false
	_is_playing = true
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func close() -> bool:
	if !data: return false
	if !_is_playing or _is_opening or _is_closing: return false
	_is_playing = false
	_is_closing = true
	unloading_started.emit()
	
	for o in objects:
		o.queue_free()
	objects = []
	
	if _cell: _cell.enabled = false
	_cell = null
	data = null
	unloading_finished.emit()
	randomize()
	_is_closing = false
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func save(path_stem: String = "") -> bool:
	if !data: return false
	if path_stem == "" and data.guid != "": path_stem = data.guid
	assert(path_stem != "")
	saving_started.emit()
	WorldData.write(data, path_stem)
	saving_finished.emit()
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #


func get_environment() -> Environment: return _environment.environment

func set_environment(value: Environment) -> void: if _environment.environment != value: _environment.environment = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_cell() -> WorldCell: return _cell

func change_cell(new_cell: WorldCell) -> void:
	if _cell == new_cell: return
	if _cell:
		print("<| %s" % [_cell.name])
		_cell.enabled = false
	_cell = new_cell
	if _cell:
		print(">| %s" % [_cell.name])
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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
