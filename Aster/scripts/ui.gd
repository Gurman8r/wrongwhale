# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: HUD = $HUD
@onready var inventory_interface: InventoryInterface = $InventoryInterface

func _init():
	Game.ui = self

func toggle_hud() -> void:
	hud.visible = not hud.visible

func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
