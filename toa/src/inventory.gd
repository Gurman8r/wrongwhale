# inventory.gd
class_name Inventory
extends Control

@onready var grid_container = $MarginContainer/GridContainer

var slots: Array[InventorySlot]

func set_inventory_data(inventory_data: InventoryData) -> void:
	if not inventory_data.inventory_updated.is_connected(populate_item_grid):
		inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	if inventory_data.inventory_updated.is_connected(populate_item_grid):
		inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	slots = []
	for child in grid_container.get_children():
		child.queue_free()
	for stack in inventory_data.stacks:
		var slot = Prefabs.INVENTORY_SLOT.instantiate()
		slot.index = slots.size()
		slots.append(slot)
		grid_container.add_child(slot)
		slot.clicked.connect(inventory_data.on_slot_clicked)
		if stack: slot.set_stack(stack)
