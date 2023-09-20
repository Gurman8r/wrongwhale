# ui.gd
class_name UI
extends CanvasLayer
func _init(): Game.ui = self

@onready var hud: HUD = $HUD
@onready var dialog_box = $DialogBox

