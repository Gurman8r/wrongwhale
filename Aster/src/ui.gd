# ui.gd
class_name UI
extends CanvasLayer

@onready var game        : GameUI = $GameUI
@onready var title       : TitleUI = $TitleUI
@onready var transitions : TransitionsUI = $TransitionUI
@onready var debug       : DebugUI = $DebugUI

func _init() -> void:
	assert(Game.ui == null)
	Game.ui = self
