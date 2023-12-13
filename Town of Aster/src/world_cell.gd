# world_cell.gd
class_name WorldCell
extends GridMap

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	World.cells.append(self)

func _ready() -> void:
	set_enabled(false)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var enabled: bool = false : set = set_enabled

func set_enabled(value: bool) -> void:
	Util.set_enabled(self, value)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _get_root(root_name: String) -> Node3D:
	assert(0 < root_name.length())
	if has_node(root_name):
		return get_node(root_name)
	else:
		var root = Node3D.new()
		root.name = root_name
		add_child(root)
		return root

func get_root_name(node: Node3D) -> String:
	assert(node)
	if node is ActorCharacter: return "Actor"
	elif node is Chest: return "Chest"
	elif node is Door: return "Door"
	elif node is ItemDrop: return "Item"
	elif node is PlayerCharacter: return "Player"
	elif node is FarmTile: return "Tile"
	return "Misc"

func get_root_node(node: Node3D) -> Node3D:
	assert(node)
	return _get_root(get_root_name(node))

func add(node: Node3D, location: Vector3 = Vector3.ZERO) -> WorldCell:
	assert(node)
	get_root_node(node).add_child(node)
	node.global_transform.origin = location
	return self

func remove(node: Node3D) -> WorldCell:
	assert(node)
	get_root_node(node).remove_child(node)
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
