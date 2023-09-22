# item_inventory_data.gd
class_name ItemInventoryData
extends Resource

@export var item_stacks: Array[ItemStack]

signal inventory_interact(inventory_data: ItemInventoryData, index: int, button: int)
signal inventory_updated(inventory_data: ItemInventoryData)

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)

func grab_stack(index: int) -> ItemStack:
	var stack = item_stacks[index]
	if !stack: return null
	item_stacks[index] = null
	inventory_updated.emit(self)
	return stack

func grab_split_stack(index: int) -> ItemStack:
	var stack = item_stacks[index]
	if !stack: return null
	if stack.quantity == 1:
		item_stacks[index] = null
	else:
		var half_quantity = stack.quantity / 2
		item_stacks[index] = stack.duplicate()
		item_stacks[index].quantity -= half_quantity
		stack.quantity = half_quantity
	inventory_updated.emit(self)
	return stack

func drop_stack(grabbed_stack: ItemStack, index: int) -> ItemStack:
	var stack = item_stacks[index]
	var return_stack: ItemStack
	if stack and stack.can_fully_merge_with(grabbed_stack):
		stack.fully_merge_with(grabbed_stack)
	else:
		item_stacks[index] = grabbed_stack
		return_stack = stack
	inventory_updated.emit(self)
	return return_stack

func drop_single(grabbed_stack: ItemStack, index: int) -> ItemStack:
	var stack = item_stacks[index]
	if not stack:
		item_stacks[index] = grabbed_stack.create_single_stack()
	elif stack.can_merge_with(grabbed_stack):
		stack.fully_merge_with(grabbed_stack.create_single_stack())
	inventory_updated.emit(self)
	if 0 < grabbed_stack.quantity:
		return grabbed_stack
	else:
		return null

func pick_up_stack(stack: ItemStack) -> bool:
	for index in item_stacks.size():
		if item_stacks[index] and item_stacks[index].can_fully_merge_with(stack):
			item_stacks[index].fully_merge_with(stack)
			inventory_updated.emit(self)
			return true
	for index in item_stacks.size():
		if not item_stacks[index]:
			item_stacks[index] = stack
			inventory_updated.emit(self)
			return true
	return false

func use_stack(index: int) -> void:
	var stack = item_stacks[index]
	if not stack: return
	if stack.item_data is ItemDataConsumable:
		stack.quantity -= 1
		if stack.quantity < 1:
			item_stacks[index] = null
	stack.item_data.use(Game.player)
	inventory_updated.emit(self)
