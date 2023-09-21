# inventory.gd
class_name Inventory
extends PanelContainer

const slot_prefab = preload("res://scenes/inventory_slot.tscn")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	populate_item_grid(inventory_data.slot_datas)

func populate_item_grid(value: Array[InventorySlotData]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	for slot_data in value:
		var slot = slot_prefab.instantiate()
		item_grid.add_child(slot)
		if slot_data:
			slot.set_slot_data(slot_data)
