# player.gd
class_name Player
extends CharacterBody3D

signal toggle_inventory()
signal primary_action()
signal secondary_action()
signal move(dir: Vector3)
signal move_collide(body: KinematicCollision3D)

@export var data: PlayerData
@export var move_speed: float = 5
@export var turn_speed: float = 15
@export var drop_range: float = 2
@export var target_range: float = 1
@export var camera_speed: Vector2 = Vector2(0.005, 0.005)
@export var camera_angle_min_degrees: float = -70
@export var camera_angle_max_degrees: float = 15

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var camera_pivot_y = $CameraPivotY
@onready var camera_pivot_x = $CameraPivotY/CameraPivotX
@onready var camera_3d = $CameraPivotY/CameraPivotX/Camera3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var interact_ray = $InteractRay
@onready var mesh_instance_3d = $MeshInstance3D
@onready var target_marker = $TargetMarker

enum { LEFT, RIGHT, FORWARD, BACKWARD }
var move_input: Array[bool] = [0, 0, 0, 0]
var direction: Vector3 = Vector3.FORWARD
var last_position: Vector3 = Vector3.ZERO

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.player = self

func _ready() -> void:
	last_position = global_transform.origin
	primary_action.connect(_on_primary_action)
	secondary_action.connect(_on_secondary_action)
	move.connect(_on_move)
	move_collide.connect(_on_move_collide)
	
func _input(event) -> void:
	if event is InputEventMouseMotion:
		camera_pivot_y.rotate_y(-event.relative.x * camera_speed.x)
		camera_pivot_x.rotate_x(-event.relative.y * camera_speed.y)
		camera_pivot_x.rotation.x = clamp( \
			camera_pivot_x.rotation.x, \
			deg_to_rad(camera_angle_min_degrees), \
			deg_to_rad(camera_angle_max_degrees))

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("inventory"): toggle_inventory.emit()
	if Input.is_action_just_pressed("primary"): primary_action.emit()
	if Input.is_action_just_pressed("secondary"): secondary_action.emit()
	var l: bool = Input.is_action_pressed("move_left")
	var r: bool = Input.is_action_pressed("move_right")
	var f: bool = Input.is_action_pressed("move_forward")
	var b: bool = Input.is_action_pressed("move_backward")
	move_input[LEFT] = l and not r
	move_input[RIGHT] = r and not l
	move_input[FORWARD] = f and not b
	move_input[BACKWARD] = b and not f

func _process(delta: float) -> void:
	# update movement
	var move_axes: Vector3 = Vector3.ZERO
	if move_input[LEFT]: move_axes -= camera_pivot_y.transform.basis.x
	elif move_input[RIGHT]: move_axes += camera_pivot_y.transform.basis.x
	if move_input[FORWARD]: move_axes -= camera_pivot_y.transform.basis.z
	elif move_input[BACKWARD]: move_axes += camera_pivot_y.transform.basis.z
	move_axes.y = 0
	move_axes = move_axes.normalized()
	if move_axes.x != 0 and move_axes.z != 0:
		last_position = global_transform.origin
		direction = (direction + move_axes).normalized()
		move.emit(move_axes)
	var body = move_and_collide(move_axes * move_speed * delta)
	if body: move_collide.emit(body)
	
	# update rotation
	var rot: Basis = mesh_instance_3d.basis.slerp(Basis.looking_at(direction), turn_speed * delta)
	mesh_instance_3d.basis = rot
	interact_ray.basis = rot
	
	# update targeting
	var target_y: float = target_marker.global_transform.origin.y
	target_marker.global_transform.origin = global_transform.origin + direction * target_range
	target_marker.global_transform.origin.x = int(target_marker.global_transform.origin.x)
	target_marker.global_transform.origin.z = int(target_marker.global_transform.origin.z)
	target_marker.global_transform.origin.y = target_y

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

func get_drop_position() -> Vector3:
	var pos: Vector3 = global_transform.origin + direction * drop_range
	pos.y = 0.5
	return pos

func warp(world_cell: WorldCell, location: Vector3 = Vector3.ZERO) -> void:
	Ref.ui.transition.fadeout()
	await Ref.ui.transition.finished
	Ref.world.cell.remove(self)
	Ref.world.cell = world_cell
	Ref.world.cell.add(self, location)
	Ref.ui.transition.fadein()
	await Ref.ui.transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_primary_action() -> void:
	pass
	
func _on_secondary_action() -> void:
	pass

func _on_move(_direction: Vector3) -> void:
	pass
	
func _on_move_collide(_body: KinematicCollision3D) -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
