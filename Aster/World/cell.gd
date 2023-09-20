# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# cell.gd
class_name Cell
extends Node3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var _actor: Node3D = $Actor
@onready var _environment: Node3D = $Environment
@onready var _item: Node3D = $Item
@onready var _miscellaneous: Node3D = $Miscellaneous
@onready var _player: Node3D = $Player

@export var data: CellData

var actors: Array[Actor]
var items: Array[Item]
var players: Array[Player]
var is_loaded: bool = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(self._actor)
	assert(self._environment)
	assert(self._item)
	assert(self._miscellaneous)
	assert(self._player)
	Game.world.register_cell(self)
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
