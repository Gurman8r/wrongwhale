# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: GameOverlay = $GameOverlay
@onready var game: GameInterface = $GameInterface
@onready var title: TitleInterface = $TitleInterface
@onready var transitions: Transitions = $Transitions
@onready var debug: DebugOverlay = $DebugOverlay

func _init() -> void:
	assert(not Ref.ui)
	Ref.ui = self
