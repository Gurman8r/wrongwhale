# ui.gd
class_name UI
extends CanvasLayer

@onready var game_overlay: GameOverlay = $GameOverlay
@onready var game_interface: GameInterface = $GameInterface
@onready var title_interface: TitleInterface = $TitleInterface
@onready var debug_overlay: DebugOverlay = $DebugOverlay

func _init() -> void:
	Ref.ui = self
