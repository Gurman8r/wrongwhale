# hotbar_inventory.gd
class_name HotbarInventory
extends PanelContainer

const item_slot_prefab = preload("res://assets/scenes/item_slot.tscn")

@onready var h_box_container = $MarginContainer/HBoxContainer

var item_index: int = 0 : set = set_item_index

var slots: Array[ItemSlot] = []

func set_inventory_data(inventory_data: InventoryData) -> void:
	if not inventory_data.inventory_updated.is_connected(populate_item_grid):
		inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	if inventory_data.inventory_updated.is_connected(populate_item_grid):
		inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	slots.clear()
	for child in h_box_container.get_children():
		child.queue_free()
	for i in range(0, 10):
		var stack = inventory_data.stacks[i]
		var slot = item_slot_prefab.instantiate()
		slots.append(slot)
		h_box_container.add_child(slot)
		if stack: slot.set_stack(stack)
		slot.selected = i == item_index

func set_item_index(value: int) -> HotbarInventory:
	if value < 0: value = 9
	elif value > 9: value = 0
	slots[item_index].selected = false
	item_index = value
	slots[item_index].selected = true
	return self

func next() -> HotbarInventory:
	return set_item_index(item_index + 1)

func prev() -> HotbarInventory:
	return set_item_index(item_index - 1)
