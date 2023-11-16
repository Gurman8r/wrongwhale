# actor.gd
class_name Actor
extends CharacterBody3D

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: ActorData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	data.cell_name = get_cell().name

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var cell: WorldCell : get = get_cell, set = set_cell
	
func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

func set_cell(value: WorldCell) -> Actor:
	Ref.world.transfer(self, value, data.position, false)
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_from_memory(world_data: WorldData) -> Actor:
	if not world_data.actors.has(name): return self
	data = world_data.actors[name].duplicate()
	return self

func save_to_memory(world_data: WorldData) -> Actor:
	world_data.actors[name] = data.duplicate()
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
