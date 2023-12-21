# world_entity.gd
class_name TreeEntity
extends WorldEntity

const CATEGORY := "Tree"

@export var data: TreeData

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var collider           : CollisionShape3D = $Collider
@onready var interactable       : Interactable     = $Interactable
@onready var rig                : Node3D           = $Rig
