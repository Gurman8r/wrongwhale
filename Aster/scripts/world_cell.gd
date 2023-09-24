# world_cell.gd
class_name WorldCell
extends GridMap

@export var world_environment: WorldEnvironment
@export var world_light: DirectionalLight3D

enum { ITEM, MISC, PLAYER, }
@onready var item_root: Node3D = $Item
@onready var misc_root: Node3D = $Misc
@onready var player_root: Node3D = $Player
@onready var root: Array[Node3D] = [ item_root, misc_root, player_root ]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(Ref.world.add_cell(self))

func _ready():
	root = [ item_root, misc_root, player_root ]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func add_object(type: int, value: Node3D, location: Vector3 = Vector3.ZERO) -> void:
	root[type].add_child(value)
	value.global_transform.origin = location

func remove_object(type: int, value: Node3D) -> void:
	root[type].remove_child(value)

func get_object_type(value: Node3D) -> int:
	if not value: return -1
	elif value is Player: return PLAYER
	elif value is ItemEntity: return ITEM
	else: return MISC

func add(value: Node3D, location: Vector3 = Vector3.ZERO) -> void:
	var type: int = get_object_type(value)
	if type < 0: return
	else: add_object(type, value, location)

func remove(value: Node3D) -> void:
	var type: int = get_object_type(value)
	if type < 0: return
	else: remove_object(type, value)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_visibility_changed():
	set_physics_process(visible)
	set_process_input(visible)
	set_process_unhandled_input(visible)
