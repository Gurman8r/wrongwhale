# world_cell.gd
class_name WorldCell
extends GridMap

@onready var actor_root: Node3D = $Actor
@onready var item_root: Node3D = $Item
@onready var light_root: Node3D = $Light
@onready var misc_root: Node3D = $Misc
@onready var player_root: Node3D = $Player
@onready var tile_root: Node3D = $Tile

var enabled: bool : set = set_enabled

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world.cells.append(self)

func _ready():
	visibility_changed.connect(_on_visibility_changed)
	set_enabled(false)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_root(node: Node3D) -> Node3D:
	if not node: return null
	elif node is Actor: return actor_root
	elif node is Light3D: return light_root
	elif node is ItemDrop: return item_root
	elif node is Player: return player_root
	elif node is WorldTile: return tile_root
	else: return misc_root

func add(node: Node3D, location: Vector3 = Vector3.ZERO) -> void:
	if not node: return
	get_root(node).add_child(node)
	node.global_transform.origin = location

func remove(node: Node3D) -> void:
	if not node: return
	get_root(node).remove_child(node)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_enabled(value: bool) -> void:
	enabled = value
	_set_enabled(self, value)

func _set_enabled(node: Node, value: bool) -> void:
	if not node: return
	for child in node.get_children():
		_set_enabled(child, value)
	node.set_physics_process(value)
	node.set_physics_process_internal(value)
	node.set_process(value)
	node.set_process_input(value)
	node.set_process_internal(value)
	node.set_process_shortcut_input(value)
	node.set_process_unhandled_input(value)
	node.set_process_unhandled_key_input(value)
	if "disabled" in node: node.disabled = not value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_visibility_changed() -> void:
	set_enabled(visible)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
