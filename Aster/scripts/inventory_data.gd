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

func drop_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	var slot_data = slot_datas[index]
	slot_datas[index] = grabbed_slot_data
	inventory_updated.emit(self)
	return slot_data
