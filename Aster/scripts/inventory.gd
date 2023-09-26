# inventory.gd
class_name Inventory
extends PanelContainer

const item_slot = preload("res://scenes/item_slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	for stack in inventory_data.items:
		var slot = item_slot.instantiate()
		item_grid.add_child(slot)
		slot.clicked.connect(inventory_data.on_slot_clicked)
		if stack:
			slot.set_stack(stack)
