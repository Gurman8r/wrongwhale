# player.gd
class_name Player
extends CharacterBody3D

signal toggle_inventory()

@export var data: PlayerData

@export var walk_speed: float = 5
@export var run_speed: float = 10
@export var pan_speed: Vector2 = Vector2(0.005, 0.005)

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D
@onready var collision_shape_3d = $CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D
@onready var interact_ray = $InteractRay

var direction: Vector3

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.players.append(self)
	if !Game.player && Game.players.size() == 1:
		Game.player = self

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * pan_speed.x)
		camera_pivot.rotate_x(-event.relative.y * pan_speed.y)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -TAU/2, TAU/2)

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

func _process(delta):
	direction = Vector3()
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	direction = direction.normalized()
	var sprint_pressed: bool = Input.is_action_pressed("sprint")
	var speed: float = walk_speed
	if sprint_pressed: speed = run_speed
	var _collision = move_and_collide(direction * speed * delta)

func _physics_process(delta : float) -> void:
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var pan_dir: Vector2 = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var sprint_pressed: bool = Input.is_action_pressed("sprint")
	var speed: float = walk_speed
	if sprint_pressed: speed = run_speed
	var move_vec = Vector3(move_dir.x, 0, move_dir.y) * speed * delta
	if move_vec != Vector3.ZERO:
		var _collision = move_and_collide(move_vec)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func get_drop_position() -> Vector3:
	var direction = -global_transform.basis.z
	return global_position + (direction * 2)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
