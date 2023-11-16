# ui.gd
class_name UI
extends CanvasLayer

@onready var hud: UI_HUD = $HUD
@onready var game: UI_Game = $Game
@onready var title: UI_Title = $Title
@onready var transition: UI_Transition = $Transition
@onready var debug: UI_Debug = $Debug

func _init() -> void:
	assert(not Ref.ui)
	Ref.ui = self

func set_player_data(player_data: PlayerData) -> void:
	game.set_player_data(player_data)
	hud.hotbar.set_inventory_data(player_data.inventory)

func clear_player_data():
	game.clear_player_data()
