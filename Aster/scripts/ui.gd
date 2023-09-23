# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: HudInterface = $HudInterface
@onready var item: ItemInterface = $ItemInterface
@onready var menu: MenuInterface = $MenuInterface
@onready var debug: DebugInterface = $DebugInterface

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.ui = self

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
