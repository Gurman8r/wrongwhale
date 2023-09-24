# world_cell.gd
class_name WorldCell
extends GridMap

@onready var world_environment = $WorldEnvironment
@onready var world_light = $WorldLight

func _init() -> void:
	Ref.world.cells.append(self)
