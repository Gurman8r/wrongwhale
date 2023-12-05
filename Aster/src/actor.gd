# actor.gd
class_name Actor
extends CharacterBody3D

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: ActorData = null

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var collision_shape_3d = $CollisionShape3D
@onready var interact_ray = $InteractRay
@onready var mesh_instance_3d = $MeshInstance3D
@onready var state_machine = $StateMachine
@onready var target_marker = $TargetMarker

func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _process(_delta):
	if not data: return

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _read(_world_data: WorldData) -> Actor:
	return self

func _write(_world_data: WorldData) -> Actor:
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
