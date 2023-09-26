# player_data.gd
class_name PlayerData
extends Resource

@export var guid: String = "Player_New"
@export var name: String = "New Player"
@export var index: int = 0

@export var position: Vector3
@export var direction: Vector3

@export var inventory: InventoryData
@export var equip: InventoryDataEquip
