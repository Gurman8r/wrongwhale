# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# cell.gd
extends Node3D
class_name Cell

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var _environment: Node3D = $Environment
@onready var _actors: Node3D = $Actors
@onready var _items: Node3D = $Items
@onready var _players: Node3D = $Players

@export var data: CellData

var actors: Array[Actor]
var items: Array[Item]
var players: Array[Player]
var is_loaded: bool = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(self._environment, "Cell environment root not found")
	assert(self._actors, "Cell actor root not found")
	assert(self._items, "Cell item root not found")
	assert(self._players, "Cell player root not found")
	refresh_actors()
	refresh_items()
	refresh_players()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func refresh_actors():
	var to_remove = []
	self.actors.clear()
	for child in self._actors.get_children():
		if child is Actor:
			self.actors.append(child)
		else:
			to_remove.append(child)
	for child in to_remove:
		self._actors.remove_child(child)
	
func add_actor(value: Actor):
	pass

func remove_actor(value: Actor):
	pass

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func refresh_items():
	var to_remove = []
	self.items.clear()
	for child in self._items.get_children():
		if child is Item:
			self.items.append(child)
		else:
			to_remove.append(child)
	for child in to_remove:
		self._items.remove_child(child)
	
func add_item(value: Item):
	pass

func remove_item(value: Item):
	pass

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func refresh_players():
	var to_remove = []
	self.players.clear()
	for child in self._players.get_children():
		if child is Player:
			self.players.append(child)
		else:
			to_remove.append(child)
	for child in to_remove:
		self._players.remove_child(child)
	
func add_player(value: Player):
	pass

func remove_player(value: Player):
	pass

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
