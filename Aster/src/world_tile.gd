# world_tile.gd
class_name WorldTile
extends StaticBody3D

@export var data: WorldTileData = null

@onready var collision_shape_3d = $CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D
@onready var interactable = $Interactable

var cell: WorldCell : get = get_cell
func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _read(_world_data: WorldData) -> WorldTile:
	return self

func _write(_world_data: WorldData) -> WorldTile:
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
