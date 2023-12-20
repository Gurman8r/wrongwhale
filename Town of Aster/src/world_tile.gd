# world_tile.gd
class_name WorldTile
extends Node3D

const CATEGORY := "Tile"

func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell
