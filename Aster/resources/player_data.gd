# player_data.gd
class_name PlayerData
extends Resource

@export var version: int = 1
@export var guid: String = "Player_New"
@export var name: String = "New Player"

@export var index: int = 0
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD
@export var cell_name: String = ""

@export var inventory: InventoryData = InventoryData.new()
@export var equip: InventoryDataEquip = InventoryDataEquip.new()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func copy(value: PlayerData) -> PlayerData:
	if self == value: return self
	
	self.version = value.version
	self.guid = value.guid
	self.name = value.name
	
	self.index = value.index
	self.position = value.position
	self.direction = value.direction
	self.cell_name = value.cell_name
	
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
