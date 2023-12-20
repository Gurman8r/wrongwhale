# chest_entity.gd
class_name ChestEntity
extends WorldEntity

const CATEGORY := "Chest"

signal toggle_inventory(external_inventory_owner)

@export var data: ChestData

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var collider           : CollisionShape3D = $Collider
@onready var interactable       : Interactable     = $Interactable
@onready var rig                : Node3D           = $Rig

func _ready() -> void:
	interactable.interacted.connect(func(_other) -> void:
		toggle_inventory.emit(self))
