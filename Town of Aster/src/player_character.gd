# player_character.gd
class_name PlayerCharacter
extends WorldCharacter

enum { LEFT, RIGHT, FORWARD, BACKWARD }
enum { PRIMARY_BEGIN, PRIMARY, PRIMARY_END, SECONDARY_BEGIN, SECONDARY, SECONDARY_END, }

@export var data: PlayerData

@export var move_speed: float = 5
@export var turn_speed: float = 15
@export var drop_range: float = 2
@export var target_range: float = 1
@export var camera_speed: Vector2 = Vector2(0.005, 0.005)
@export var camera_angle_min_degrees: float = -70
@export var camera_angle_max_degrees: float = 15

@onready var animation_player   : AnimationPlayer  = $AnimationPlayer
@onready var animation_tree     : AnimationTree    = $AnimationTree
@onready var camera_pivot_y     : Node3D           = $CameraPivotY
@onready var camera_pivot_x     : SpringArm3D      = $CameraPivotY/CameraPivotX
@onready var camera_3d          : Camera3D         = $CameraPivotY/CameraPivotX/Camera3D
@onready var collision_shape_3d : CollisionShape3D = $CollisionShape3D
@onready var interact_ray       : InteractRay      = $InteractRay
@onready var mesh_instance_3d   : MeshInstance3D   = $MeshInstance3D
@onready var state_machine      : StateMachine     = $StateMachine
@onready var target_marker      : Node3D           = $TargetMarker

func get_right() -> Vector3: return camera_pivot_y.transform.basis.x
func get_left() -> Vector3: return -camera_pivot_y.transform.basis.x
func get_backward() -> Vector3: return camera_pivot_y.transform.basis.z
func get_forward() -> Vector3: return -camera_pivot_y.transform.basis.z

var move_input: Array[bool] = [0, 0, 0, 0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	assert(Player.character == null)
	Player.character = self

func _ready() -> void:
	assert(data)
	Player.data = data

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _process(delta: float) -> void:
	if not data: return
	
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
		Player.move.emit(delta, move_axes)
		if body: Player.move_collide.emit(body)
	data.position = global_transform.origin
		
	# update rotation
	if data.direction != Vector3.ZERO:
		var rot: Basis = mesh_instance_3d.basis.slerp(Basis.looking_at(data.direction), turn_speed * delta)
		mesh_instance_3d.basis = rot
		interact_ray.basis = rot
	
	# update targeting
	var target_pos: Vector3 = data.position + data.direction * target_range
	target_marker.global_transform.origin.x = roundf(target_pos.x)
	target_marker.global_transform.origin.z = roundf(target_pos.z)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func pivot(relative: Vector2) -> void:
	camera_pivot_y.rotate_y(-relative.x * camera_speed.x)
	camera_pivot_x.rotate_x(-relative.y * camera_speed.y)
	camera_pivot_x.rotation.x = clamp( \
		camera_pivot_x.rotation.x, \
		deg_to_rad(camera_angle_min_degrees), \
		deg_to_rad(camera_angle_max_degrees))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_drop_position() -> Vector3:
	var pos: Vector3 = global_transform.origin + data.direction * drop_range
	pos.y = 0.5
	return pos

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
