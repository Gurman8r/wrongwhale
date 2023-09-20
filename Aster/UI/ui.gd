# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# ui.gd
class_name UI
extends CanvasLayer

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var hud: HUD = $HUD
@onready var title: Title = $Title

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	Game.ui = self

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
