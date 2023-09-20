# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# item.gd
class_name Item
extends Area3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

@export var data: ItemData
@export var count: int = 1

func _ready():
	self.mesh_instance.mesh = self.data.mesh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
