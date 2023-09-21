# inventory_slot.gd
class_name InventorySlot
extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $QuantityLabel

func set_slot_data(slot_data: InventorySlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	if slot_data.quantity > 1:
		quantity_label.text = "(%s)" % [slot_data.quantity]
		quantity_label.show()
