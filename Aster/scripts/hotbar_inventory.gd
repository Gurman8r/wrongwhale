# hotbar_inventory.gd
class_name HotbarInventory
extends PanelContainer

const slot_prefab = preload("res://scenes/item_slot.tscn")

@onready var h_box_container = $MarginContainer/HBoxContainer

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
	for slot_data in inventory_data.slot_datas.slice(0, 10):
		var slot = slot_prefab.instantiate()
		h_box_container.add_child(slot)
		if slot_data:
			slot.set_slot_data(slot_data)
