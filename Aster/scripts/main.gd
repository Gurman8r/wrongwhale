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
	Game.player.toggle_inventory.connect(Game.ui.toggle_inventory_interface)
	Game.ui.inventory_interface.set_player_inventory_data(Game.player.data.inventory)
	Game.ui.inventory_interface.set_equip_inventory_data(Game.player.data.equip_inventory)
	Game.ui.hotbar_inventory.set_inventory_data(Game.player.data.inventory)
