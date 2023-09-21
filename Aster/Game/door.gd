# door.gd
class_name Door
extends MeshInstance3D

@export var spawn_point: Node3D
@export var destination: Door

func _on_interacted(other):
	pass
