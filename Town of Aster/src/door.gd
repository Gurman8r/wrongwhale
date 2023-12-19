# door.gd
class_name Door
extends WorldObject

const CATEGORY := "Door"

@export var destination: Door

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var interactable: Interactable = $Interactable
@onready var spawn_point: Node3D = $SpawnPoint

func _ready() -> void:
	interactable.interacted.connect(func(other) -> void:
		assert(destination)
		assert(destination.spawn_point)
		if other == Player.character:
			Transition.play("fadeout")
			await Transition.finished
		World.transfer(
			other,
			destination.get_cell(),
			destination.spawn_point.global_transform.origin)
		if other == Player.character:
			Transition.play("fadein")
			await Transition.finished)
