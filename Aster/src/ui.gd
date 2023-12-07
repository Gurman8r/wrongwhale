# ui.gd
class_name UI
extends CanvasLayer

@onready var game: Control = $GameUI
@onready var title: Control = $TitleUI
@onready var transitions: Control = $TransitionUI
@onready var debug: Control = $DebugUI

func _init() -> void:
	assert(Game.ui == null)
	Game.ui = self
