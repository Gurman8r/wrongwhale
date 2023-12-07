# actor_character.gd
class_name ActorCharacter
extends WorldCharacter

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: ActorData = null

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var collision_shape_3d = $CollisionShape3D
@onready var interact_ray = $InteractRay
@onready var mesh_instance_3d = $MeshInstance3D
@onready var state_machine = $StateMachine
@onready var target_marker = $TargetMarker

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
