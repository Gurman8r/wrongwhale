# main.gd
class_name Main
extends Node

enum State {
	NONE,
	TITLE_SPLASH,
	TITLE_MAIN,
	TITLE_LOAD,
	GAME_PLAYING,
	GAME_PAUSED,
}

@export var state: State = State.NONE

func _init():
	Game.main = self

func _ready():
	assert(Game.ui.inventory_interface)
	Game.player.toggle_inventory.connect(Game.ui.toggle_inventory_interface)
	Game.ui.inventory_interface.set_player_inventory_data(Game.player.data.inventory)
