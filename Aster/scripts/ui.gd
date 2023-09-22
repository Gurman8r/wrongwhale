# ui.gd
class_name UI
extends CanvasLayer

const item_drop_prefab = preload("res://scenes/item_drop.tscn")

@onready var hotbar_inventory = $HUD/HotbarInventory
@onready var interact_label = $HUD/InteractLabel
@onready var item_interface: InventoryInterface = $ItemInterface

var block_input: bool = false

func _init() -> void:
	Game.ui = self

func _ready() -> void:
	block_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_item_interface)

func toggle_item_interface(external_inventory_owner = null) -> void:
	item_interface.visible = not item_interface.visible
	
	if item_interface.visible:
		block_input = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hotbar_inventory.hide()
	else:
		block_input = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hotbar_inventory.show()
	
	if external_inventory_owner and item_interface.visible:
		item_interface.set_external_inventory(external_inventory_owner)
	else:
		item_interface.clear_external_inventory()

func _on_item_interface_drop_stack(stack):
	print("HERE")
	var item_drop: ItemDrop = item_drop_prefab.instantiate()
	item_drop.stack = stack
	item_drop.position = Game.player.get_drop_position()
	add_child(item_drop)
