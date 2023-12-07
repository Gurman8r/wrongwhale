# world_static.gd
class_name WorldStatic
extends StaticBody3D

func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell
