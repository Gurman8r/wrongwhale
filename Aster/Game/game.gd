# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# game.gd
extends Node

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

enum { LEFT, RIGHT, UP, DOWN, }

enum {
	STATE_MENU,
	STATE_GAME,
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
