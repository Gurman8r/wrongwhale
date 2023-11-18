# tile.gd
class_name  Tile
extends StaticBody3D

var cell: WorldCell : get = get_cell
func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell
