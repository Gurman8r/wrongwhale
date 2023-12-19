# crop.gd
class_name Crop
extends WorldObject

@export var data: CropData

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var collider           : CollisionShape3D = $Collider
@onready var rig                : MeshInstance3D   = $Rig
@onready var state_machine      : StateMachine     = $StateMachine
