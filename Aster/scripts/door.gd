# door.gd
class_name Door
extends StaticBody3D

@export var destination: Door

@onready var spawn_point: Node3D = $SpawnPoint

func _on_interacted(_other) -> void:
	var target_cell: WorldCell = destination.cell
	var target_pos: Vector3 = destination.spawn_point.global_transform.origin
	Ref.world.transfer(Ref.player, target_cell, target_pos)
