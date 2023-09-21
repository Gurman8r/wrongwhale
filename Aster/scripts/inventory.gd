# inventory.gd
class_name Inventory
extends PanelContainer

const slot_prefab = preload("res://scenes/inventory_slot.tscn")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

func _ready():
	var inventory_data = preload("res://resources/test_inventory.tres")
	set_inventory_data(inventory_data)

func set_inventory_data(inventory_data: InventoryData) -> void:
	populate_item_grid(inventory_data.slots)

func populate_item_grid(slots: Array[InventorySlotData]) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	for slot_data in slots:
		var slot = slot_prefab.instantiate()
		item_grid.add_child(slot)
