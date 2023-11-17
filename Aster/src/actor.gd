# actor.gd
class_name Actor
extends CharacterBody3D

@export var data: ActorData

var cell: WorldCell : get = get_cell

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
	
func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
