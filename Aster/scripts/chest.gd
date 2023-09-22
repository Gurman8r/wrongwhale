# chest.gd
class_name Chest
extends Interactable

@export var inventory_data: ItemInventoryData

signal toggle_inventory(external_inventory_owner)

func _on_interacted(other) -> void:
	toggle_inventory.emit(self)
