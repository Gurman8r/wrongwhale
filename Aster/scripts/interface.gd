# interface.gd
class_name Interface
extends CanvasLayer

@onready var hud: Control = $HUD
@onready var hotbar_inventory = $HUD/ItemHotbar
@onready var interact_label: Label = $HUD/InteractLabel

@onready var item_interface: ItemInterface = $ItemInterface
@onready var menu_interface: MenuInterface = $MenuInterface
@onready var debug_interface: DebugInterface = $DebugInterface

var block_input: bool = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.ui = self

func _ready() -> void:
	block_input = false
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_item_interface)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func toggle_hud() -> void:
	hud.visible = not hud.visible

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

func toggle_menu_interface() -> void:
	menu_interface.visible = not menu_interface.visible

func toggle_debug_interface() -> void:
	debug_interface.visible = not debug_interface.visible

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
