# door_entity.gd
class_name DoorEntity
extends WorldEntity

const CATEGORY := "Door"

@export var destination: DoorEntity

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var collider           : CollisionShape3D = $Collider
@onready var interactable       : Interactable     = $Interactable
@onready var rig                : Node3D           = $Rig
@onready var spawn_point        : Node3D           = $SpawnPoint

func _ready() -> void:
	interactable.interacted.connect(func(other) -> void:
		assert(destination)
		assert(destination.spawn_point)
		if other == Player.character:
			Transition.play("fadeout")
			await Transition.finished
		World.transfer(
			other,
			destination.get_cell(),
			destination.spawn_point.global_transform.origin)
		if other == Player.character:
			Transition.play("fadein")
			await Transition.finished)
