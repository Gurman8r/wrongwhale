# door.gd
class_name Door
extends WorldObject

@export var destination: Door

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var interactable: Interactable = $Interactable
@onready var spawn_point: Node3D = $SpawnPoint

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted(other) -> void:
	assert(destination)
	assert(destination.spawn_point)
	Ref.world.transfer(
		other,
		destination.cell,
		destination.spawn_point.global_transform.origin,
		other == Ref.player)
