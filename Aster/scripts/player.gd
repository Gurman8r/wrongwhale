# player.gd
class_name Player
extends CharacterBody3D

@export var data: PlayerData
@export var walk_speed: float = 5
@export var run_speed: float = 10
@export var turn_speed: float = 15
@export var camera_speed: Vector2 = Vector2(0.005, 0.005)
@export var camera_angle_min_degrees: float = -70
@export var camera_angle_max_degrees: float = 15

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var camera_pivot_y = $CameraPivotY
@onready var camera_pivot_x = $CameraPivotY/CameraPivotX
@onready var camera_3d = $CameraPivotY/CameraPivotX/Camera3D
@onready var collision_shape_3d = $CollisionShape3D
@onready var interact_ray = $InteractRay
@onready var mesh_instance_3d = $MeshInstance3D
@onready var target_marker = $TargetMarker

var enabled: bool : set = set_enabled
enum { LEFT, RIGHT, FORWARD, BACKWARD, SPRINT, }
var inputs: Array[bool] = [0, 0, 0, 0, 0]
var move_dir: Vector3 = Vector3.ZERO
var look_dir: Vector3 = Vector3.FORWARD

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.player = self

func _input(event) -> void:
	if event is InputEventMouseMotion:
		camera_pivot_y.rotate_y(-event.relative.x * camera_speed.x)
		camera_pivot_x.rotate_x(-event.relative.y * camera_speed.y)
		camera_pivot_x.rotation.x = clamp( \
			camera_pivot_x.rotation.x, \
			deg_to_rad(camera_angle_min_degrees), \
			deg_to_rad(camera_angle_max_degrees))

func _unhandled_input(_event) -> void:
	inputs[LEFT] = Input.is_action_pressed("move_left")
	inputs[RIGHT] = Input.is_action_pressed("move_right")
	inputs[FORWARD] = Input.is_action_pressed("move_forward")
	inputs[BACKWARD] = Input.is_action_pressed("move_backward")
	inputs[SPRINT] = Input.is_action_pressed("sprint")

func _process(delta):
	move_dir = Vector3()
	if inputs[LEFT]: move_dir -= camera_pivot_y.transform.basis.x
	elif inputs[RIGHT]: move_dir += camera_pivot_y.transform.basis.x
	if inputs[FORWARD]: move_dir -= camera_pivot_y.transform.basis.z
	elif inputs[BACKWARD]: move_dir += camera_pivot_y.transform.basis.z
	move_dir.y = 0
	move_dir = move_dir.normalized()
	if move_dir.x != 0 and move_dir.z != 0:
		look_dir = (look_dir + move_dir).normalized()
	var move_speed: float = walk_speed
	if inputs[SPRINT]: move_speed = run_speed
	var _collision = move_and_collide(move_dir * move_speed * delta)
	
	var look_rot: Basis = mesh_instance_3d.basis.slerp(Basis.looking_at(look_dir), turn_speed * delta)
	mesh_instance_3d.basis = look_rot
	interact_ray.basis = look_rot
	
	var target_pos: Vector3 = target_marker.global_transform.origin
	target_pos = global_transform.origin + look_dir
	target_pos.y = 0.5
	target_marker.global_transform.origin = target_pos

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func set_enabled(value: bool):
	enabled = value
	if enabled:
		Game.player.set_process_input(true)
		Game.player.set_process_unhandled_input(true)
	else:
		Game.player.set_process_input(false)
		Game.player.set_process_unhandled_input(false)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
