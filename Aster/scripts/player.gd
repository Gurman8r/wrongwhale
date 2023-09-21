# player.gd
class_name Player
extends CharacterBody3D

signal toggle_inventory()

@export var data: PlayerData

@export var walk_speed: float = 5
@export var run_speed: float = 10
@export var pan_speed: Vector2 = Vector2(0.005, 0.005)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera: Camera3D = $Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var interact_ray: InteractRay = $InteractRay
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	Game.players.append(self)
	if !Game.player && Game.players.size() == 1:
		Game.player = self

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

func _physics_process(delta : float) -> void:
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var pan_dir: Vector2 = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var sprint_pressed: bool = Input.is_action_pressed("sprint")
	
	var move_speed: float = walk_speed
	if sprint_pressed: move_speed = run_speed
	var move_vec = Vector3(move_dir.x, 0, move_dir.y) * move_speed * delta
	if move_vec != Vector3.ZERO:
		move_and_collide(move_vec)

func get_drop_position() -> Vector3:
	var direction = -global_transform.basis.z
	return global_position + (direction * 2)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
