# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# cell.gd
class_name Cell
extends Node3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# root nodes
@onready var _actor: Node3D = $Actor
@onready var _item: Node3D = $Item
@onready var _light: Node3D = $Light
@onready var _map: Node3D = $Map
@onready var _misc: Node3D = $Misc
@onready var _player: Node3D = $Player

@export var data: CellData

var actors: Array[Actor]
var items: Array[Item]
var players: Array[Player]
var is_loaded: bool = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(self._actor)
	assert(self._item)
	assert(self._light)
	assert(self._map)
	assert(self._misc)
	assert(self._player)
	Game.world.register_cell(self)
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
