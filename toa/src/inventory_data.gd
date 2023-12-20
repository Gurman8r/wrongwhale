# inventory_data.gd
class_name InventoryData
extends Resource

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_updated(inventory_data: InventoryData)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var stacks: Array[ItemStack]

func resize(count: int) -> InventoryData:
	stacks.resize(count)
	return self

func get_item(index: int) -> ItemData:
	assert(index >= 0 and index < stacks.size())
	var stack = stacks[index]
	if stack: return stack.item_data
	else: return null

func set_item(index: int, item_data: ItemData, quantity: int = 1) -> void:
	assert(index >= 0 and index < stacks.size())
	assert(0 < quantity)
	var stack = stacks[index]
	if !stack:
		stacks[index] = ItemStack.new()
		stack = stacks[index]
	assert(stack)
	stack.item_data = item_data
	stack.quantity = quantity
	inventory_updated.emit(self)

func add_item(item_data: ItemData, quantity: int = 1) -> bool:
	assert(item_data)
	assert(0 < quantity)
	var stack: ItemStack = null
	for i in range(stacks.size()):
		if stacks[i] == null:
			stacks[i] = ItemStack.new()
			stack = stacks[i]
			break
	if stack == null: return false
	stack.item_data = item_data
	stack.quantity = quantity
	inventory_updated.emit(self)
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)

func grab_stack(index: int) -> ItemStack:
	var stack = stacks[index]
	if !stack: return null
	stacks[index] = null
	inventory_updated.emit(self)
	return stack

func grab_split_stack(index: int) -> ItemStack:
	var stack = stacks[index]
	if !stack: return null
	if stack.quantity == 1:
		stacks[index] = null
	else:
		var half_quantity = stack.quantity / 2
		stacks[index] = stack.duplicate()
		stacks[index].quantity -= half_quantity
		stack.quantity = half_quantity
	inventory_updated.emit(self)
	return stack

func drop_stack(grabbed_stack: ItemStack, index: int) -> ItemStack:
	var stack = stacks[index]
	var return_stack: ItemStack
	if stack and stack.can_fully_merge_with(grabbed_stack):
		stack.fully_merge_with(grabbed_stack)
	else:
		stacks[index] = grabbed_stack
		return_stack = stack
	inventory_updated.emit(self)
	return return_stack

func drop_single(grabbed_stack: ItemStack, index: int) -> ItemStack:
	var stack = stacks[index]
	if not stack:
		stacks[index] = grabbed_stack.create_single_stack()
	elif stack.can_merge_with(grabbed_stack):
		stack.fully_merge_with(grabbed_stack.create_single_stack())
	inventory_updated.emit(self)
	if 0 < grabbed_stack.quantity:
		return grabbed_stack
	else:
		return null

func pick_up_stack(stack: ItemStack) -> bool:
	for index in stacks.size():
		if stacks[index] and stacks[index].can_fully_merge_with(stack):
			stacks[index].fully_merge_with(stack)
			inventory_updated.emit(self)
			return true
	for index in stacks.size():
		if not stacks[index]:
			stacks[index] = stack
			inventory_updated.emit(self)
			return true
	return false

func use_stack(index: int, mode: int, target: Node) -> void:
	var stack = stacks[index]
	if not stack: return
	stack.item_data.use(self, index, mode, target)
	inventory_updated.emit(self)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
