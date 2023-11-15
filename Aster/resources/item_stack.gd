# item_stack.gd
class_name ItemStack
extends Resource

const MAX: int = 9999

@export var item_data: ItemData = ItemData.new()
@export_range(1, MAX) var quantity: int = 1 : set = set_quantity

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func can_merge_with(other_stack: ItemStack) -> bool:
	return item_data == other_stack.item_data \
		and 1 < item_data.max_stack \
		and quantity < MAX

func can_fully_merge_with(other_stack: ItemStack) -> bool:
	return item_data == other_stack.item_data \
		and 1 < item_data.max_stack \
		and quantity + other_stack.quantity <= MAX

func fully_merge_with(other_stack: ItemStack) -> void:
	quantity += other_stack.quantity

func create_single_stack() -> ItemStack:
	var new_stack: ItemStack = duplicate()
	new_stack.quantity = 1
	quantity -= 1
	return new_stack

func set_quantity(value: int) -> void:
	if value > item_data.max_stack:
		quantity = item_data.max_stack
	else:
		quantity = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
