# inventory_data.gd
class_name InventoryData
extends Resource

@export var version: int = 1
@export var items: Array[ItemStack]

signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_updated(inventory_data: InventoryData)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func copy(value: InventoryData):
	if self == value: return self
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_item_data(index: int) -> ItemData:
	var stack = get_item_stack(index)
	if stack:
		return stack.item_data
	else:
		return null

func get_item_stack(index: int):
	if index >= 0 and index < items.size():
		return items[index]
	else:
		return null

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)

func grab_stack(index: int) -> ItemStack:
	var stack = items[index]
	if !stack: return null
	items[index] = null
	inventory_updated.emit(self)
	return stack

func grab_split_stack(index: int) -> ItemStack:
	var stack = items[index]
	if !stack: return null
	if stack.quantity == 1:
		items[index] = null
	else:
		var half_quantity = stack.quantity / 2
		items[index] = stack.duplicate()
		items[index].quantity -= half_quantity
		stack.quantity = half_quantity
	inventory_updated.emit(self)
	return stack

func drop_stack(grabbed_stack: ItemStack, index: int) -> ItemStack:
	var stack = items[index]
	var return_stack: ItemStack
	if stack and stack.can_fully_merge_with(grabbed_stack):
		stack.fully_merge_with(grabbed_stack)
	else:
		items[index] = grabbed_stack
		return_stack = stack
	inventory_updated.emit(self)
	return return_stack

func drop_single(grabbed_stack: ItemStack, index: int) -> ItemStack:
	var stack = items[index]
	if not stack:
		items[index] = grabbed_stack.create_single_stack()
	elif stack.can_merge_with(grabbed_stack):
		stack.fully_merge_with(grabbed_stack.create_single_stack())
	inventory_updated.emit(self)
	if 0 < grabbed_stack.quantity:
		return grabbed_stack
	else:
		return null

func pick_up_stack(stack: ItemStack) -> bool:
	for index in items.size():
		if items[index] and items[index].can_fully_merge_with(stack):
			items[index].fully_merge_with(stack)
			inventory_updated.emit(self)
			return true
	for index in items.size():
		if not items[index]:
			items[index] = stack
			inventory_updated.emit(self)
			return true
	return false

func use_stack(index: int) -> void:
	var stack = items[index]
	if not stack: return
	if stack.item_data is ItemDataConsumable:
		stack.quantity -= 1
		if stack.quantity < 1:
			items[index] = null
	stack.item_data.use(Ref.player)
	inventory_updated.emit(self)
