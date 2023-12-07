# actor_data.gd
class_name ActorData
extends Resource

const PREFAB := preload("res://assets/scenes/actor_character.tscn")

@export var guid: String
@export var name: String

@export var cell_name: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD

@export var gender: int = 1
@export var pronoun0: String = "She"
@export var pronoun1: String = "Her"
