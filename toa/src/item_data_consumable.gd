# item_data_consumable.gd
class_name ItemDataConsumable
extends ItemData

func use(owner: InventoryData, index: int, state: int, target: Node) -> void:
	var stack = owner.stacks[index]
	if state == SECONDARY_END:
		stack.quantity -= 1
		if stack.quantity < 1:
			owner.stacks[index] = null
		Debug.puts("%s consumed %s" % [target.name, to_string()])
