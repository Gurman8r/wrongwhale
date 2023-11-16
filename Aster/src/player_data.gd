# player_data.gd
class_name PlayerData
extends Resource

@export var guid: String = "Player_New"
@export var name: String = "New Player"
@export var index: int = 0
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD
@export var cell_name: String = ""

@export var stats: Stats
@export var inventory: InventoryData
@export var equip: InventoryDataEquip
