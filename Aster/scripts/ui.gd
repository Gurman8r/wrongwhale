# ui.gd
class_name UI
extends CanvasLayer

const item_drop_prefab = preload("res://scenes/item_drop.tscn")

@onready var hotbar_inventory = $HUD/HotbarInventory
@onready var prompt_label = $HUD/PromptLabel
@onready var inventory_interface: InventoryInterface = $InventoryInterface

var block_input: bool = false

func _init() -> void:
	Game.ui = self

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	block_input = false
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hotbar_inventory.hide()
		block_input = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hotbar_inventory.show()
		block_input = false
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()

func _on_inventory_interface_drop_stack(stack):
	print("HERE")
	var item_drop: ItemDrop = item_drop_prefab.instantiate()
	item_drop.stack = stack
	item_drop.position = Game.player.get_drop_position()
	add_child(item_drop)
