# actor_character.gd
@icon("res://assets/icons/icon_actor.png")
class_name ActorCharacter
extends WorldCharacter

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const CATEGORY := "Actor"

@export var data: ActorData

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var collider           : CollisionShape3D = $Collider
@onready var interact_ray       : InteractRay      = $InteractRay
@onready var rig                : Node3D           = $Rig
@onready var state_machine      : StateMachine     = $StateMachine
@onready var target_marker      : Node3D           = $TargetMarker

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
