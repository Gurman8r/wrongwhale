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

func _ready():
	assert(self.actor_root)
	assert(self.item_root)
	assert(self.light_root)
	assert(self.map_root)
	assert(self.misc_root)
	assert(self.player_root)
	assert(Game.world.register_cell(self))
	
func _notification(_n):
	if _n == NOTIFICATION_PREDELETE:
		assert(Game.world.unregister_cell(self))
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
