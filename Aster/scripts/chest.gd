# chest.gd
class_name Chest
extends Interactable

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

@onready var collision_shape_3d = $CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D

func _on_interacted(_other) -> void:
	toggle_inventory.emit(self)

func _on_cell_visibility_changed() -> void:
	collision_shape_3d.disabled = not cell.visible
