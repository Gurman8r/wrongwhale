# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: HUD = $HUD

func _init():
	assert(Global.ui == null)
	Global.ui = self
