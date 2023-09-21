# chest.gd
class_name Chest
extends Interactable

@export var inventory_data: InventoryData

signal toggle_inventory(external_inventory_owner)

func _on_interacted(_other):
	toggle_inventory.emit(self)
