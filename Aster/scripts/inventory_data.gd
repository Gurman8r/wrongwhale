# inventory_data.gd
class_name InventoryData
extends Resource

@export var slot_datas: Array[ItemSlotData]

signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_updated(inventory_data: InventoryData)

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)

func grab_slot_data(index: int) -> ItemSlotData:
	var slot_data = slot_datas[index]
	if !slot_data: return null
	slot_datas[index] = null
	inventory_updated.emit(self)
	return slot_data

func grab_split_slot_data(index: int):
	var slot_data = slot_datas[index]
	if !slot_data: return null
	if slot_data.quantity == 1:
		slot_datas[index] = null
	else:
		var half_quantity = slot_data.quantity / 2
		slot_datas[index] = slot_data.duplicate()
		slot_datas[index].quantity -= half_quantity
		slot_data.quantity = half_quantity
	inventory_updated.emit(self)
	return slot_data

func drop_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	var slot_data = slot_datas[index]
	var return_slot_data: ItemSlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	var slot_data = slot_datas[index]
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	inventory_updated.emit(self)
	if 0 < grabbed_slot_data.quantity:
		return grabbed_slot_data
	else:
		return null

func pick_up_slot_data(slot_data: ItemSlotData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			inventory_updated.emit(self)
			return true
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	return false

func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]
	if not slot_data: return
	if slot_data.item_data is ItemDataConsumable:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
	slot_data.item_data.use(Game.player)
	inventory_updated.emit(self)
