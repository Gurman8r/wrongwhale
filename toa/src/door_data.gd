# door_data.gd
class_name DoorData
extends Resource

@export var guid: String = "Door"
@export var name: String = "Door"
@export var cell_name: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD

@export var target_cell: String
@export var target_door: String
