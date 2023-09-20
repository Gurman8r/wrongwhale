# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# game.gd
extends Node

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

enum {
	STATE_SPLASH,
	STATE_TITLE,
	STATE_MAINMENU,
	STATE_GAME,
}

enum {
	WEST, LEFT = WEST,
	EAST, RIGHT = EAST,
	NORTH, UP = NORTH,
	SOUTH, DOWN = SOUTH,
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

var world: World
var ui: UI

var player: Player
var players: Array[Player]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(self.world, "Game.world not set")
	assert(self.ui, "Game.ui not set")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func register_player(player: Player) -> void:
	pass

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
