# hotbar.gd
class_name Hotbar
extends PanelContainer

const item_slot = preload("res://scenes/item_slot.tscn")

@export var item_index: int = 0 : set = set_item_index

@onready var h_box_container = $MarginContainer/HBoxContainer

var slots: Array[ItemSlot]

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData) -> void:
	slots.clear()
	for child in h_box_container.get_children():
		child.queue_free()
	var i: int = 0
	for stack in inventory_data.items.slice(0, 10):
		var slot = item_slot.instantiate()
		slots.append(slot)
		h_box_container.add_child(slot)
		if stack:
			slot.set_stack(stack)
		slot.selected = i == item_index
		i += 1

func set_item_index(value: int) -> void:
	if value <= 0: value = 9
	elif value > 9: value = 0
	slots[item_index].selected = false
	item_index = value
	slots[item_index].selected = true
