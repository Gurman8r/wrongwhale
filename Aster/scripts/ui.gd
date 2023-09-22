# ui.gd
class_name UI
extends CanvasLayer

const item_drop_prefab = preload("res://scenes/item_drop.tscn")

@onready var hud: UI_HUD = $HUD
@onready var hotbar_inventory = $HUD/HotbarInventory
@onready var inventory_interface: InventoryInterface = $InventoryInterface

func _init() -> void:
	Game.ui = self

func _ready() -> void:
	var player: Player = Game.player
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.data.inventory)
	inventory_interface.set_equip_inventory_data(player.data.equipment)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	hotbar_inventory.set_inventory_data(player.data.inventory)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hotbar_inventory.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hotbar_inventory.show()
	
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
