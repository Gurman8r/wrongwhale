# ui.gd
class_name UI
extends CanvasLayer

@onready var game: GameUI = $GameUI
@onready var title: TitleUI = $TitleUI
@onready var transitions: TransitionUI = $TransitionUI
@onready var debug: DebugUI = $DebugUI

func _init() -> void:
	assert(G.ui == null)
	G.ui = self
