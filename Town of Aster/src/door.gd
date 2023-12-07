# door.gd
class_name Door
extends WorldObject

@export var destination: Door

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var interactable: Interactable = $Interactable
@onready var spawn_point: Node3D = $SpawnPoint

func _ready() -> void:
	interactable.interacted.connect(func(other) -> void:
		assert(destination)
		assert(destination.spawn_point)
		if other == Game.player:
			Game.transitions_ui.play("fadeout")
			await Game.transitions_ui.finished
		Game.world.transfer(
			other,
			destination.get_cell(),
			destination.spawn_point.global_transform.origin)
		if other == Game.player:
			Game.transitions_ui.play("fadein")
			await Game.transitions_ui.finished)
