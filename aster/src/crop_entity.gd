# crop_entity.gd
class_name CropEntity
extends WorldEntity

const CATEGORY := "Crop"

@export var data: CropData

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var collider           : CollisionShape3D = $Collider
@onready var interactable       : Interactable     = $Interactable
@onready var rig                : Node3D           = $Rig
