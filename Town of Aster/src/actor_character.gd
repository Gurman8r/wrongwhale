# actor_character.gd
class_name ActorCharacter
extends WorldCharacter

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var data: ActorData

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var interact_ray: InteractRay = $InteractRay
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var state_machine: StateMachine = $StateMachine
@onready var target_marker: Node3D = $TargetMarker

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
