# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# ui.gd
extends CanvasLayer
class_name UI

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@export var hud: HUD
@export var title: Title

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	print("UI init")
	Game.ui = self
	self.hud = $HUD
	self.title = $Title

func _ready():
	print("UI ready")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
