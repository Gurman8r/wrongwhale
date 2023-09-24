# world_cell.gd
class_name WorldCell
extends GridMap

@export var world_environment: WorldEnvironment
@export var world_light: DirectionalLight3D

@onready var item_root: Node3D = $Item
@onready var misc_root: Node3D = $Misc
@onready var player_root: Node3D = $Player

func _init() -> void:
	Ref.world.cells.append(self)

func get_object_root(value: Node3D) -> Node3D:
	if not value: return null
	elif value is Player: return player_root
	elif value is ItemEntity: return item_root
	else: return misc_root

func add(value: Node3D, location: Vector3 = Vector3.ZERO) -> void:
	if not value: return
	get_object_root(value).add_child(value)
	value.global_transform.origin = location

func remove(value: Node3D) -> void:
	if not value: return
	get_object_root(value).remove_child(value)
