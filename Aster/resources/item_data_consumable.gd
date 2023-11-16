# item_data_consumable.gd
class_name ItemDataConsumable
extends ItemData

func use(owner: InventoryData, index: int, mode: int, target: Node) -> void:
	if mode == SECONDARY_PRESSED:
		owner.stacks[index].quantity -= 1
		if owner.stacks[index].quantity < 1:
			owner.stacks[index] = null
		print("%s consumed %s" % [target.name, to_string()])
