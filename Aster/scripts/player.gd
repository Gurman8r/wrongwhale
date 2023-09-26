# player.gd
class_name Player
extends CharacterBody3D

signal toggle_inventory()
signal primary_action()
signal secondary_action()
signal move(delta: float, direction: Vector3)
signal move_collision(body: KinematicCollision3D)

@export var data: PlayerData
@export var move_speed: float = 5
@export var turn_speed: float = 15
@export var drop_range: float = 2
@export var target_range: float = 1
@export var camera_speed: Vector2 = Vector2(0.005, 0.005)
@export var camera_angle_min_degrees: float = -70
@export var camera_angle_max_degrees: float = 15

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera_pivot_y: Node3D = $CameraPivotY
@onready var camera_pivot_x: SpringArm3D = $CameraPivotY/CameraPivotX
@onready var camera_3d: Camera3D = $CameraPivotY/CameraPivotX/Camera3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var interact_ray: InteractRay = $InteractRay
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var target_marker: Node3D = $TargetMarker

enum { LEFT, RIGHT, FORWARD, BACKWARD }
var move_input: Array[bool] = [0, 0, 0, 0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.player = self

func _ready() -> void:
	primary_action.connect(_on_primary_action)
	secondary_action.connect(_on_secondary_action)
	move.connect(_on_move)
	move_collision.connect(_on_move_collision)
	Ref.main.world_loading.connect(_on_world_loading)
	Ref.main.world_saving.connect(_on_world_saving)
	Ref.main.world_unloading.connect(_on_world_unloading)
	
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
	move_input[LEFT] = Input.is_action_pressed("move_left")
	move_input[RIGHT] = Input.is_action_pressed("move_right")
	move_input[FORWARD] = Input.is_action_pressed("move_forward")
	move_input[BACKWARD] = Input.is_action_pressed("move_backward")

func _process(delta: float) -> void:
	# update movement
	var move_axes: Vector3 = Vector3.ZERO
	if move_input[LEFT]: move_axes -= camera_pivot_y.transform.basis.x
	elif move_input[RIGHT]: move_axes += camera_pivot_y.transform.basis.x
	if move_input[FORWARD]: move_axes -= camera_pivot_y.transform.basis.z
	elif move_input[BACKWARD]: move_axes += camera_pivot_y.transform.basis.z
	move_axes.y = 0
	move_axes = move_axes.normalized()
	if move_axes.x != 0 or move_axes.z != 0:
		data.direction = (data.direction + move_axes).normalized()
		var body = move_and_collide(move_axes * move_speed * delta)
		move.emit(delta, move_axes)
		if body: move_collision.emit(body)
		
	# update rotation
	if data.direction != Vector3.ZERO:
		var rot: Basis = mesh_instance_3d.basis.slerp(Basis.looking_at(data.direction), turn_speed * delta)
		mesh_instance_3d.basis = rot
		interact_ray.basis = rot
	
	# update targeting
	var target_y: float = target_marker.global_transform.origin.y
	target_marker.global_transform.origin = global_transform.origin + data.direction * target_range
	target_marker.global_transform.origin.x = roundf(target_marker.global_transform.origin.x)
	target_marker.global_transform.origin.z = roundf(target_marker.global_transform.origin.z)
	target_marker.global_transform.origin.y = target_y

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_drop_position() -> Vector3:
	var pos: Vector3 = global_transform.origin + data.direction * drop_range
	pos.y = 0.5
	return pos

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_primary_action() -> void:
	pass
	
func _on_secondary_action() -> void:
	pass

func _on_move(_delta: float, _direction: Vector3) -> void:
	pass
	
func _on_move_collision(_body: KinematicCollision3D) -> void:
	pass

func _on_world_loading(world_data: WorldData):
	assert(world_data.player_data)
	assert(0 < world_data.player_data.size())
	global_transform.origin = world_data.player_data[data.guid].position
	
func _on_world_saving(world_data: WorldData):
	world_data.player_data[data.guid].position = global_transform.origin

func _on_world_unloading():
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
