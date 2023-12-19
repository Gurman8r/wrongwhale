# chest.gd
class_name Chest
extends WorldObject

const CATEGORY := "Chest"

signal toggle_inventory(external_inventory_owner)

@export var data: ChestData

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	interactable.interacted.connect(func(_other) -> void:
		toggle_inventory.emit(self))
