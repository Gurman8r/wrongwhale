# player_data.gd
class_name PlayerData
extends Resource

@export var guid: String = "Player_New"
@export var name: String = "New Player"
@export var index: int = 0
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD
@export var cell_name: String = ""

@export var inventory: InventoryData = InventoryData.new()
@export var equip: InventoryDataEquip = InventoryDataEquip.new()

@export var health: int = 100
@export var health_max: int = 100
@export var stamina: int = 100
@export var stamina_max: int = 100
@export var mana: int = 100
@export var mana_max: int = 100

@export var attack: int = 1
@export var defense: int = 1
@export var speed: int = 1
