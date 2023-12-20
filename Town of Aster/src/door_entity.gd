# door_entity.gd
class_name DoorEntity
extends WorldEntity

const CATEGORY := "Door"

@export var data: DoorData

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var collider           : CollisionShape3D = $Collider
@onready var interactable       : Interactable     = $Interactable
@onready var rig                : Node3D           = $Rig
@onready var spawn_point        : Node3D           = $SpawnPoint

func _ready() -> void:
	interactable.interacted.connect(func(other) -> void:
		assert(data)
		
		var target_cell: WorldCell = World.find_cell(data.target_cell)
		assert(target_cell)
		
		var target_door: DoorEntity = target_cell.find(CATEGORY, data.target_door)
		assert(target_door)
		assert(target_door.spawn_point)
		
		if other == Player.character:
			Transition.play("fadeout")
			await Transition.finished
		
		World.transfer(
			other,
			target_cell,
			target_door.spawn_point.global_transform.origin)
		
		if other == Player.character:
			Transition.play("fadein")
			await Transition.finished)
