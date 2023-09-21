# game.gd
extends Node

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

var main: Main: set = set_main
var world: World: set = set_world
var ui: UI: set = set_ui

var player: Player
var players: Array[Player]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(main, "Game.main is invalid")
	assert(world, "Game.world is invalid")
	assert(ui, "Game.ui is invalid")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func set_main(value: Main):
	assert(!main, "Game.main is already assigned")
	assert(value, "Game.main cannot be assigned to null")
	main = value

func set_world(value: World):
	assert(!world, "Game.world is already assigned")
	assert(value, "Game.world cannot be assigned to null")
	world = value
	
func set_ui(value: UI):
	assert(!ui, "Game.ui is already assigned")
	assert(value, "Game.ui cannot be assigned to null")
	ui = value

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
