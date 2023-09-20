# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# ui.gd
class_name UI
extends CanvasLayer

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var hud: HUD = $HUD
@onready var debug: Debug = $DEBUG

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	Game.ui = self

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
