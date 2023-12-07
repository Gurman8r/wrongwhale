# world.gd
# World
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# ui
var interface: WorldInterface
var overlay: WorldOverlay

# lighting
var environment: WorldEnvironment

# cells
var cell_root: Node
var cell: WorldCell = null : set = change_cell
var cells: Array[WorldCell] = []
var objects: Array[Node3D] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = Utility.make(self, WorldInterface.PREFAB, "Interface")
	overlay = Utility.make(self, WorldOverlay.PREFAB, "Overlay")
	reset()

func reset() -> void:
	reset_environment()
	reset_cells()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset_environment() -> void:
	if environment == null:
		environment = WorldEnvironment.new()
		add_child(environment)
		environment.name = "Environment"
	environment.environment = preload("res://assets/data/environment.tres").duplicate()

func get_environment() -> Environment:
	return environment.environment

func set_environment(value: Environment) -> void:
	environment.environment = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset_cells() -> void:
	cell_root = preload("res://assets/scenes/world_cells.tscn").instantiate()
	add_child(cell_root)
	cell_root.name = "Cells"

func get_cell() -> WorldCell:
	return cell

func change_cell(new_cell: WorldCell) -> void:
	if cell == new_cell: return
	if cell: cell.enabled = false
	cell = new_cell
	if cell: cell.enabled = true

func find_cell(cell_name: String) -> WorldCell:
	if has_node(cell_name): return get_node(cell_name) as WorldCell
	else: return null

func transfer(node: Node3D, new_cell: WorldCell, position: Vector3 = Vector3.ZERO) -> void:
	assert(node)
	assert(new_cell)
	if cell: cell.remove(node)
	change_cell(new_cell)
	if cell: cell.add(node, position)
	if "data" in node and "cell_name" in node.data:
		node.data.cell_name = cell.name

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
