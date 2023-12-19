# actor_data.gd
class_name ActorData
extends Resource

const PREFAB = Prefabs.ACTOR_CHARACTER

@export var guid: String = "Actor"
@export var name: String = "Actor"
@export var cell_name: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var direction: Vector3 = Vector3.FORWARD

@export var gender: int = 0
@export var pronoun0: String = "She"
@export var pronoun1: String = "Her"
