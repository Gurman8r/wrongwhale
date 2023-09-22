# player.gd
class_name Player
extends CharacterBody3D

signal toggle_inventory()

@export var data: PlayerData

@export var walk_speed: float = 5
@export var run_speed: float = 10
@export var turn_speed: float = 15
@export var camera_speed: Vector2 = Vector2(0.005, 0.005)

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var camera_pivot_y = $CameraPivotY
@onready var camera_pivot_x = $CameraPivotY/CameraPivotX
@onready var camera_3d = $CameraPivotY/CameraPivotX/Camera3D
@onready var collision_shape_3d = $CollisionShape3D
@onready var interact_ray = $InteractRay
@onready var mesh_instance_3d = $MeshInstance3D
@onready var target_marker = $TargetMarker

var move_dir: Vector3
var look_dir: Vector3 = Vector3.FORWARD

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.players.append(self)
	if !Game.player && Game.players.size() == 1:
		Game.player = self

func _input(event) -> void:
	if Game.ui.block_input: return
	if event is InputEventMouseMotion:
		camera_pivot_y.rotate_y(-event.relative.x * camera_speed.x)
		camera_pivot_x.rotate_x(-event.relative.y * camera_speed.y)
		camera_pivot_x.rotation.x = clamp(camera_pivot_x.rotation.x, deg_to_rad(-70), deg_to_rad(15))

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

func _process(delta):
	if Game.ui.block_input: return
	
	move_dir = Vector3()
	if Input.is_action_pressed("move_left"): move_dir -= camera_pivot_y.transform.basis.x
	elif Input.is_action_pressed("move_right"): move_dir += camera_pivot_y.transform.basis.x
	if Input.is_action_pressed("move_forward"): move_dir -= camera_pivot_y.transform.basis.z
	elif Input.is_action_pressed("move_backward"): move_dir += camera_pivot_y.transform.basis.z
	move_dir.y = 0
	move_dir = move_dir.normalized()
	look_dir = (look_dir + move_dir).normalized()
	
	var look_rot: Basis = mesh_instance_3d.basis.slerp(Basis.looking_at(look_dir), turn_speed * delta)
	mesh_instance_3d.basis = look_rot
	interact_ray.basis = look_rot
	
	var target_pos: Vector3 = target_marker.global_transform.origin
	target_pos = global_transform.origin + look_dir
	target_pos.y = 0.5
	target_marker.global_transform.origin = target_pos
	
	var move_speed: float = walk_speed
	if Input.is_action_pressed("sprint"): move_speed = run_speed
	var _collision = move_and_collide(move_dir * move_speed * delta)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func get_drop_position() -> Vector3:
	return global_position + (-global_transform.basis.z * 2)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
