# player_data.gd
class_name PlayerData
extends Resource

@export var guid: String = "Player_New"
@export var name: String = "New Player"

@export var inventory: InventoryData = preload("res://resources/default_inventory_data.tres")
