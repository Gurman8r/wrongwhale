# world_entity.gd
class_name WorldEntity
extends StaticBody3D

func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell

static func create(_data: Resource) -> Node3D:
	return null
