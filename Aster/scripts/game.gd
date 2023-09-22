# game.gd
extends Node

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

var main: Main
var settings: Settings
var world : World
var ui : Interface

var player: Player
var players: Array[Player]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready() -> void:
	assert(main, "Game.main is invalid")
	assert(settings, "Game.settings is invalid")
	assert(world, "Game.world is invalid")
	assert(ui, "Game.ui is invalid")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
