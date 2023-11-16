# item_data_consumable.gd
class_name ItemDataConsumable
extends ItemData

func use(owner: InventoryData, index: int, mode: int, target: Node) -> void:
	var stack = owner.stacks[index]
	if mode == SECONDARY_PRESSED and 0 < stack.quantity:
		stack.quantity -= 1
		if stack.quantity < 1:
			owner.stacks[index] = null
		print("%s consumed %s" % [target.name, to_string()])
