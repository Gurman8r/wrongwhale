# inventory_data_equip.gd
class_name InventoryDataEquip
extends InventoryData

func drop_slot_data(grabbed_slot_data: ItemStack, index: int) -> ItemStack:
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	return super.drop_slot_data(grabbed_slot_data, index)

func drop_single_slot_data(grabbed_slot_data: ItemStack, index: int) -> ItemStack:
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	return super.drop_single_slot_data(grabbed_slot_data, index)

