# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: HUD = $HUD
@onready var inventory_interface: InventoryInterface = $InventoryInterface

func _init():
	Game.ui = self

func _ready():
	pass

func toggle_inventory_interface() -> void:
	inventory_interface.visible = !inventory_interface.visible
