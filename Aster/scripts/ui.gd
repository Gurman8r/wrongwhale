# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: GameOverlay = $GameOverlay
@onready var game: GameInterface = $GameInterface
@onready var title: TitleInterface = $TitleInterface
@onready var transition: TransitionOverlay = $TransitionOverlay
@onready var debug: DebugOverlay = $DebugOverlay

func _init() -> void:
	Ref.ui = self
