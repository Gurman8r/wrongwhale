# inventory.gd
class_name Inventory
extends PanelContainer

const slot_prefab = preload("res://scenes/inventory_slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	for stack in inventory_data.stacks:
		var slot = slot_prefab.instantiate()
		item_grid.add_child(slot)
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		if stack:
			slot.set_stack(stack)
