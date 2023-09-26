# chest.gd
class_name Chest
extends Interactable

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

@onready var collision_shape_3d = $CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D

func _ready():
	interacted.connect(_on_interacted)

func _on_interacted(_other) -> void:
	toggle_inventory.emit(self)
