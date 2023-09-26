# world_object.gd
class_name WorldObject
extends StaticBody3D

var cell: WorldCell : get = get_cell

func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell

func _ready() -> void:
	Ref.main.world_loading.connect(_on_world_loading)
	Ref.main.world_saving.connect(_on_world_saving)
	Ref.main.world_unloading.connect(_on_world_unloading)

func _on_world_loading(_world_data: WorldData):
	pass
	
func _on_world_saving(_world_data: WorldData):
	pass

func _on_world_unloading():
	pass
