# actor.gd
class_name Actor
extends CharacterBody3D

@export var data: ActorData

var cell: WorldCell : get = get_cell, set = set_cell

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	data.cell_name = get_cell().name

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_from_memory(world_data: WorldData) -> Actor:
	if not world_data.actor_data.has(name): return self
	data = world_data.actor_data[name].duplicate()
	return self

func save_to_memory(world_data: WorldData) -> Actor:
	world_data.actor_data[name] = data.duplicate()
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
	
func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

func set_cell(value: WorldCell) -> Actor:
	Ref.world.transfer(self, value, data.position, false)
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
