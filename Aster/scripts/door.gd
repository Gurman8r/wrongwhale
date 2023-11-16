# door.gd
class_name Door
extends WorldObject

@export var destination: Door

@onready var spawn_point: Node3D = $SpawnPoint

func _on_interacted(other) -> void:
	Ref.world.transfer(
		other,
		destination.cell,
		destination.spawn_point.global_transform.origin,
		other == Ref.player)
