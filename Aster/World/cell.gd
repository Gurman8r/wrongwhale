# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# cell.gd
class_name Cell
extends Node3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var actor_root: Node3D = $Actor
@onready var item_root: Node3D = $Item
@onready var light_root: Node3D = $Light
@onready var map_root: Node3D = $Map
@onready var misc_root: Node3D = $Misc
@onready var player_root: Node3D = $Player

@export var data: CellData

var actors: Array[Actor]
var items: Array[Item]
var players: Array[Player]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _notification(what):
	match what:
		NOTIFICATION_READY:
			assert(self.actor_root, "cell actor root not set")
			assert(self.item_root, "cell item root not set")
			assert(self.light_root, "cell light root not set")
			assert(self.map_root, "cell map root not set")
			assert(self.misc_root, "cell misc root not set")
			assert(self.player_root, "cell player root not set")
			assert(Game.world.register_cell(self))
		NOTIFICATION_PREDELETE:
			assert(Game.world.unregister_cell(self))
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
