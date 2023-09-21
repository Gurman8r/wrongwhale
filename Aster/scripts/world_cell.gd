# world_cell.gd
class_name WorldCell
extends Node3D

func _init():
	assert(Game.world.register_cell(self))
