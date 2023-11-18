# world_cell.gd
class_name WorldCell
extends GridMap

var enabled: bool : set = set_enabled

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world.cells.append(self)

func _ready():
	set_enabled(false)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _get_root(root_name: String) -> Node3D:
	if root_name.is_empty():
		return null
	var root: Node3D = get_node(root_name)
	if not root:
		root = Node3D.new()
		add_child(root)
	return root

func get_root_name(node: Node3D) -> String:
	if not node: return ""
	elif node is Actor: return "Actor"
	elif node is ItemDrop: return "Item"
	elif node is Player: return "Player"
	elif node is WorldObject: return "Object"
	elif node is WorldTile: return "Tile"
	else: return "Misc"

func get_root_node(node: Node3D) -> Node3D:
	return _get_root(get_root_name(node))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func add(node: Node3D, location: Vector3 = Vector3.ZERO) -> void:
	if not node: return
	get_root_node(node).add_child(node)
	node.global_transform.origin = location

func remove(node: Node3D) -> void:
	if not node: return
	get_root_node(node).remove_child(node)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func enable() -> void:
	set_enabled(true)

func disable() -> void:
	set_enabled(false)

func set_enabled(value: bool) -> void:
	_set_enabled(self, value)

func _set_enabled(node: Node, value: bool) -> void:
	if not node: return
	for child in node.get_children(): _set_enabled(child, value)
	node.set_physics_process(value)
	node.set_physics_process_internal(value)
	node.set_process(value)
	node.set_process_input(value)
	node.set_process_internal(value)
	node.set_process_shortcut_input(value)
	node.set_process_unhandled_input(value)
	node.set_process_unhandled_key_input(value)
	if "visible" in node: node.visible = value
	if "disabled" in node: node.disabled = not value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
