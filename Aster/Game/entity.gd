# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# entity.gd
class_name Entity
extends CharacterBody3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var mesh_instance: MeshInstance3D = $MeshInstance
@onready var interact_ray: RayCast3D = $InteractRay

func _ready():
	assert(self.animation_player)
	assert(self.animation_tree)
	assert(self.collision_shape)
	assert(self.mesh_instance)
	assert(self.interact_ray)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# HEALTH
@export var health: float = 100
@export var healthmax: float = 100

signal health_changed(value: float)
signal healthmax_changed(value: float)

func set_health(value: float):
	if value < 0.000001: value = 0.0
	elif self.healthmax < value: value = self.healthmax
	if self.health == value: return
	self.health = value
	self.health_changed.emit(self.health)

func set_healthmax(value: float):
	if self.healthmax == value: return
	self.healthmax = value
	self.healthmax_changed.emit(self.health)
	if value < self.health: set_health(value)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
