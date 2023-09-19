# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# game.gd
extends Node

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

var world: World
var ui: UI

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	print("Game init")

func _ready():
	print("Game ready")
	assert(world, "World not found")
	assert(ui, "UI not found")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
