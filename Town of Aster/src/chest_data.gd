# chest_data.gd
class_name ChestData
extends Resource

const PREFAB := Prefabs.CHEST_ENTITY

@export var guid: String = "Chest"
@export var name: String = "Chest"
@export var cell_name: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD

@export var inventory_data: InventoryData = InventoryData.new()


static func make(guid: String, name: String) -> ChestData:
	var data: ChestData = ChestData.new()
	data.guid = guid
	data.name = name
	return data
