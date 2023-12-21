# crop_data.gd
class_name CropData
extends Resource

const PREFAB := Prefabs.CROP_ENTITY

@export var guid: String = "Crop"
@export var name: String = "Crop"
@export var cell_name: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD

@export var category: String = "Basic"
@export var sell_price: int = 0
@export var edibility: int = 0
@export var growing_seasons: Array[String] = []
@export var growing_phases: Array[int] = []
@export var regrow: bool = false
@export var scythe: bool = false
@export var trellis: bool = false
@export var flower_colors: Array[Color] = []

