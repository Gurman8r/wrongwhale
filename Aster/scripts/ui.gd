# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: HUD = $HUD
@onready var inventory_interface = $InventoryInterface

func _init():
	assert(Global.ui == null)
	Global.ui = self

func _ready():
	Global.player.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface() -> void:
	inventory_interface.visible = !inventory_interface.visible
