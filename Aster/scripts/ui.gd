# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: UI_HUD = $HUD
@onready var game: UI_Game = $Game
@onready var title: UI_Title = $Title
@onready var transition: UI_Transition = $Transition
@onready var debug: UI_Debug = $Debug

func _init() -> void:
	Ref.ui = self
