# inventory_slot_data.gd
class_name InventorySlotData
extends Resource

@export var item_data: ItemData
@export_range(1, ItemData.MAX_STACK) var quantity: int = 1 : set = set_quantity

func set_quantity(value: int) -> void:
	assert(item_data != null)
	quantity = value
	if quantity > item_data.max_stack:
		quantity = item_data.max_stack
