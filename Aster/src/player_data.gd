# player_data.gd
class_name PlayerData
extends Resource

@export var guid: String
@export var name: String
@export var index: int = 0

@export var cell_name: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD

@export var gender: int = 1
@export var pronoun0: String = "She"
@export var pronoun1: String = "Her"

@export var health: int = 100
@export var health_max: int = 100
@export var stamina: int = 100
@export var stamina_max: int = 100
@export var mana: int = 100
@export var mana_max: int = 100

@export var attack: int = 1
@export var defense: int = 1
@export var speed: int = 1

@export var inventory_data: InventoryData = InventoryData.new()
@export var equip_data: InventoryDataEquip = InventoryDataEquip.new()
