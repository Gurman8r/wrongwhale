# global.gd
extends Node

var game: Game
var world: World
var ui: UI

var player: Player
var players: Array[Player]

func _ready():
	assert(self.game, "Global.game not set")
	assert(self.world, "Global.world not set")
	assert(self.ui, "Global.ui not set")
