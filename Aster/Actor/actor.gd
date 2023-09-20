# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# actor.gd
class_name Actor
extends CharacterBody3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

@export var data: ActorData
@export var entity: Entity
@export var inventory: Inventory

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(self.animation_player)
	assert(self.animation_tree)
	assert(self.collision_shape)
	assert(self.mesh_instance)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
