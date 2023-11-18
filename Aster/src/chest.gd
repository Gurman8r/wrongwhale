# chest.gd
class_name Chest
extends StaticBody3D

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var interactable: Interactable = $Interactable

var cell: WorldCell : get = get_cell
func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell

func _ready() -> void:
	interactable.interacted.connect(func(_other) -> void:
		toggle_inventory.emit(self))
