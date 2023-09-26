# world_object.gd
class_name WorldObject
extends StaticBody3D

signal cell_visibility_changed()

var cell: WorldCell : get = get_cell

func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell
