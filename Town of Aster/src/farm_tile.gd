# world_tile.gd
class_name FarmTile
extends WorldObject

@export var data: FarmTileData = null

@onready var collision_shape_3d = $CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D
@onready var interactable = $Interactable
