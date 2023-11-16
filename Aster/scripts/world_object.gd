# world_object.gd
class_name WorldObject
extends StaticBody3D

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var cell: WorldCell : get = get_cell, set = set_cell
	
func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

func set_cell(value: WorldCell) -> WorldObject:
	Ref.world.transfer(self, value, Vector3.ZERO, false)
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
