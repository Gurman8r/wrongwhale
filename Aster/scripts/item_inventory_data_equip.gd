# item_inventory_data_equip.gd
class_name ItemInventoryDataEquip
extends ItemInventoryData

func drop_stack(grabbed_stack: ItemStack, index: int) -> ItemStack:
	if not grabbed_stack.item_data is ItemDataEquipment:
		return grabbed_stack
	return super.drop_stack(grabbed_stack, index)

func drop_single(grabbed_stack: ItemStack, index: int) -> ItemStack:
	if not grabbed_stack.item_data is ItemDataEquipment:
		return grabbed_stack
	return super.drop_single(grabbed_stack, index)

