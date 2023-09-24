# ref.gd
extends Node

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

var main: Main
var settings: Settings
var world : World
var ui : UI

var player: Player

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready() -> void:
	assert(main, "Ref.main is invalid")
	assert(settings, "Ref.settings is invalid")
	assert(world, "Ref.world is invalid")
	assert(ui, "Ref.ui is invalid")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
