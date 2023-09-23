# ui.gd
class_name UI
extends CanvasLayer

signal toggle_inventory()

@onready var hud: HudInterface = $HudInterface
@onready var item: ItemInterface = $ItemInterface
@onready var menu: MenuInterface = $MenuInterface
@onready var debug: DebugInterface = $DebugInterface

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.ui = self

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
