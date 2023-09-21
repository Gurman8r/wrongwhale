# player_data.gd
class_name PlayerData
extends Resource

@export var guid: String = "Player_New"
@export var name: String = "New Player"

@export var inventory: InventoryData
@export var equip_inventory: InventoryDataEquip
