# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# door.gd
class_name Door
extends Node3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var static_body: StaticBody3D = $MeshInstance3D/StaticBody3D
@onready var collision_shape: CollisionShape3D = $MeshInstance3D/StaticBody3D/CollisionShape3D
@onready var spawn_point: Node3D = $SpawnPoint

@export var data: DoorData

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
