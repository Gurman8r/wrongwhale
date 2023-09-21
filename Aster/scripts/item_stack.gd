# item_slot_data.gd
class_name ItemStack
extends Resource

const MAX_STACK = ItemData.MAX_STACK

@export var item_data: ItemData
@export_range(1, MAX_STACK) var quantity: int = 1 : set = set_quantity

func can_merge_with(other_slot_data: ItemStack) -> bool:
	return item_data == other_slot_data.item_data \
		and 1 < item_data.max_stack \
		and quantity < MAX_STACK

func can_fully_merge_with(other_slot_data: ItemStack) -> bool:
	return item_data == other_slot_data.item_data \
		and 1 < item_data.max_stack \
		and quantity + other_slot_data.quantity <= MAX_STACK

func fully_merge_with(other_slot_data: ItemStack) -> void:
	quantity += other_slot_data.quantity

func create_single_slot_data() -> ItemStack:
	var new_slot_data: ItemStack = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data

func set_quantity(value: int) -> void:
	if value > item_data.max_stack:
		quantity = item_data.max_stack
	else:
		quantity = value
