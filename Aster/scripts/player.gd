# player.gd
class_name Player
extends CharacterBody3D

@export var data: PlayerData
@export var move_speed: float = 5
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

enum { LEFT, RIGHT, FORWARD, BACKWARD, SPRINT }
var inputs: Array[bool] = [0, 0, 0, 0, 0]
var move_axes: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.FORWARD

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.player = self

func _input(event) -> void:
	if event is InputEventMouseMotion:
		camera_pivot_y.rotate_y(-event.relative.x * camera_speed.x)
		camera_pivot_x.rotate_x(-event.relative.y * camera_speed.y)
		camera_pivot_x.rotation.x = clamp( \
			camera_pivot_x.rotation.x, \
			deg_to_rad(camera_angle_min_degrees), \
			deg_to_rad(camera_angle_max_degrees))

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("inventory"): Ref.ui.game.show()
	inputs[LEFT] = Input.is_action_pressed("move_left")
	inputs[RIGHT] = Input.is_action_pressed("move_right")
	inputs[FORWARD] = Input.is_action_pressed("move_forward")
	inputs[BACKWARD] = Input.is_action_pressed("move_backward")
	inputs[SPRINT] = Input.is_action_pressed("sprint")

func _process(delta):
	move_axes = Vector3()
	if inputs[LEFT]: move_axes -= camera_pivot_y.transform.basis.x
	elif inputs[RIGHT]: move_axes += camera_pivot_y.transform.basis.x
	if inputs[FORWARD]: move_axes -= camera_pivot_y.transform.basis.z
	elif inputs[BACKWARD]: move_axes += camera_pivot_y.transform.basis.z
	move_axes.y = 0
	move_axes = move_axes.normalized()
	direction = (direction + move_axes).normalized()
	var _collision = move_and_collide(move_axes * move_speed * delta)
	
	var rot: Basis = mesh_instance_3d.basis.slerp(Basis.looking_at(direction), turn_speed * delta)
	mesh_instance_3d.basis = rot
	interact_ray.basis = rot
	
	var target_pos: Vector3 = global_transform.origin + direction
	target_pos.y = 0.5
	target_marker.global_transform.origin = target_pos

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_target_position() -> Vector3:
	return target_marker.global_transform.origin

func get_drop_position() -> Vector3:
	return global_transform.origin + (direction * 2)

func warp(world_cell: WorldCell, location: Vector3 = Vector3.ZERO):
	Ref.ui.transition.play_fadeout()
	await Ref.ui.transition.finished
	Ref.world.cell.remove(self)
	Ref.world.cell = world_cell
	Ref.world.cell.add(self, location)
	Ref.ui.transition.play_fadein()
	await Ref.ui.transition.finished
