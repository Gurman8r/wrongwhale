# door.gd
class_name Door
extends Interactable

@export var destination: Door

@onready var spawn_point: Node3D = $SpawnPoint

func _ready():
	interacted.connect(_on_interacted)

func _on_interacted(_other) -> void:
	assert(destination.cell)
	assert(destination.spawn_point.global_transform.origin)
	Ref.world.warp(Ref.player, destination.cell, destination.spawn_point.global_transform.origin)
