# ui.gd
class_name UI
extends CanvasLayer

@onready var game: GameInterface = $GameInterface
@onready var title: TitleInterface = $TitleInterface
@onready var transitions: TransitionInterface = $TransitionInterface
@onready var debug: DebugInterface = $DebugInterface

func _init() -> void:
	assert(Ref.ui == null)
	Ref.ui = self
