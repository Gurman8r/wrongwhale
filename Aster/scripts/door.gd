# door.gd
class_name Door
extends Interactable

@export var destination: Door

@onready var collision_shape_3d = $CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D
@onready var spawn_point = $SpawnPoint

var cell: WorldCell : get = get_cell
var spawn_position: Vector3 : get = get_spawn_position

func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

func get_spawn_position() -> Vector3:
	return spawn_point.global_transform.origin

func _on_interacted(_other) -> void:
	Ref.player.warp(destination.cell, destination.spawn_position)
