# world_object.gd
class_name WorldObject
extends StaticBody3D

func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell
