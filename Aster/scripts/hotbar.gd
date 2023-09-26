# hotbar.gd
class_name Hotbar
extends PanelContainer

const item_slot = preload("res://scenes/item_slot.tscn")

@onready var h_box_container = $MarginContainer/HBoxContainer

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
	for stack in inventory_data.items.slice(0, 10):
		var slot = item_slot.instantiate()
		h_box_container.add_child(slot)
		if stack:
			slot.set_stack(stack)
