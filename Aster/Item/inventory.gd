# inventory.gd
class_name Inventory
extends PanelContainer

const slot_prefab = preload("res://item/inventory_slot.tscn")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

func _ready():
	var inventory_data = preload("res://item/test_inventory.tres")
	populate_item_grid(inventory_data.slots)

func populate_item_grid(slots: Array[InventorySlotData]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in slots:
		var slot = slot_prefab.instantiate()
		item_grid.add_child(slot)
