# inventory_slot.gd
class_name InventorySlot
extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $QuantityLabel

func set_slot_data(slot_data: InventorySlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
