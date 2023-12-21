# inventory_hotbar.gd
class_name InventoryHotbar
extends Control

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var h_box_container = $MarginContainer/HBoxContainer

var slots: Array[InventorySlot] = []

func set_inventory_data(inventory_data: InventoryData) -> void:
	if not inventory_data.inventory_updated.is_connected(populate_item_grid):
		inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	if inventory_data.inventory_updated.is_connected(populate_item_grid):
		inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	slots = []
	for child in h_box_container.get_children():
		child.queue_free()
	for i in range(0, 10):
		var stack = inventory_data.stacks[i]
		var slot = Prefabs.INVENTORY_SLOT.instantiate()
		slot.index = slots.size()
		slots.append(slot)
		h_box_container.add_child(slot)
		if stack: slot.set_stack(stack)
		slot.highlighted = i == item_index

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region ITEM_INDEX

var _item_index: int = 0

var item_index: int : get = get_item_index, set = set_item_index

func get_item_index() -> int: return _item_index

func set_item_index(value: int) -> InventoryHotbar:
	if value < 0: value = 9
	elif value > 9: value = 0
	slots[item_index].highlighted = false
	item_index = value
	slots[item_index].highlighted = true
	return self

func next() -> InventoryHotbar: return set_item_index(item_index + 1)

func prev() -> InventoryHotbar: return set_item_index(item_index - 1)

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
