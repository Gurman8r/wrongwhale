# crop_data.gd
class_name CropData
extends Resource

@export var guid: String = "Crop"
@export var name: String = "Crop"
@export var cell_name: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD

@export var growth_stage: int = 0
