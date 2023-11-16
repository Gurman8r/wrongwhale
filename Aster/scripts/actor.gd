# actor.gd
class_name Actor
extends CharacterBody3D

@export var data: ActorData

var cell: WorldCell : get = get_cell, set = set_cell

func _ready() -> void:
	data.cell_name = get_cell().name
	
func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

func set_cell(value: WorldCell) -> void:
	Ref.world.transfer(self, value, data.position, false)

func load_from_memory(world_data: WorldData) -> void:
	pass

func save_to_memory(world_data: WorldData) -> void:
	pass
