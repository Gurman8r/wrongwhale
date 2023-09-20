# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# unit.gd
class_name Unit
extends CharacterBody3D

@export var data: UnitData

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var mesh_instance: MeshInstance3D = $MeshInstance
@onready var interact_ray: RayCast3D = $InteractRay

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _notification(what):
	match (what):
		NOTIFICATION_READY:
			assert(animation_player, "unit animation player not set")
			assert(animation_tree, "unit animation tree not set")
			assert(collision_shape, "unit collision shape not set")
			assert(mesh_instance, "unit mesh instance not set")
			assert(interact_ray, "unit interact ray set")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# HEALTH
@export var health: float = 1
@export var healthmax: float = 1

signal health_changed(value: float)
signal healthmax_changed(value: float)
signal damaged_applied(damage: Damage)
signal healing_applied(healing: Healing)

func set_health(value: float):
	if value < 0.000001: value = 0.0
	elif healthmax < value: value = healthmax
	if health == value: return
	health = value
	health_changed.emit(health)

func set_healthmax(value: float):
	if healthmax == value: return
	healthmax = value
	if value < health: set_health(value)
	healthmax_changed.emit(health)

func apply_damage(damage: Damage) -> void:
	set_health(health + damage.calculate(self))
	damaged_applied.emit(damage)

func apply_healing(healing: Healing) -> void:
	set_health(health + healing.calculate(self))
	healing_applied.emit(healing)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
