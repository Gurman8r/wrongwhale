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

var item_index: int = 0
var move_input: Array[bool] = [0, 0, 0, 0]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Player.character = self
	Player.data = data

func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			Player.character = null
			Player.data = null

func _ready() -> void:
	Player.action.connect(func(mode: int):
		Player.data.inventory_data.use_stack(item_index, mode, self))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
	
func _input(event) -> void:
	# mouse camera
	if event is InputEventMouseMotion:
		camera_pivot_y.rotate_y(-event.relative.x * camera_speed.x)
		camera_pivot_x.rotate_x(-event.relative.y * camera_speed.y)
		camera_pivot_x.rotation.x = clamp( \
			camera_pivot_x.rotation.x, \
			deg_to_rad(camera_angle_min_degrees), \
			deg_to_rad(camera_angle_max_degrees))
	
	# primary action
	if Input.is_action_just_pressed("primary"): Player.action.emit(PRIMARY_BEGIN)
	elif Input.is_action_pressed("primary"): Player.action.emit(PRIMARY)
	elif Input.is_action_just_released("primary"): Player.action.emit(PRIMARY_END)
	
	# secondary action
	if Input.is_action_just_pressed("secondary"): Player.action.emit(SECONDARY_BEGIN)
	elif Input.is_action_pressed("secondary"): Player.action.emit(SECONDARY)
	elif Input.is_action_just_released("secondary"): Player.action.emit(SECONDARY_END)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	# toggle ui
	if Input.is_action_just_pressed("toggle_debug"): Player.toggle_debug.emit()
	if Input.is_action_just_pressed("toggle_inventory"): Player.toggle_inventory.emit()
	#if Input.is_action_just_pressed("toggle_collection"): Player.interface.set_current_tab(GameUI.COLLECTION)
	#if Input.is_action_just_pressed("toggle_skills"): Player.interface.set_current_tab(GameUI.SKILLS)
	#if Input.is_action_just_pressed("toggle_journal"): Player.interface.set_current_tab(GameUI.JOURNAL)
	#if Input.is_action_just_pressed("toggle_options"): Player.interface.set_current_tab(GameUI.OPTIONS)
	#if Input.is_action_just_pressed("toggle_system"): Player.interface.set_current_tab(GameUI.SYSTEM)
	
	# hotbar
	if Input.is_action_just_released("hotbar_prev"): Player.hotbar_prev.emit()
	elif Input.is_action_just_released("hotbar_next"): Player.hotbar_next.emit()
	for i in range(0, 10):
		if Input.is_action_just_pressed("hotbar_%d" % [i]):
			Player.overlay.hotbar_inventory.set_item_index(i - 1)
			Player.hotbar_select.emit(i - 1)
			break
	item_index = Player.overlay.hotbar_inventory.item_index
	
	# movement
	move_input[LEFT] = Input.is_action_pressed("move_left")
	move_input[RIGHT] = Input.is_action_pressed("move_right")
	move_input[FORWARD] = Input.is_action_pressed("move_forward")
	move_input[BACKWARD] = Input.is_action_pressed("move_backward")

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

func get_drop_position() -> Vector3:
	var pos: Vector3 = global_transform.origin + data.direction * drop_range
	pos.y = 0.5
	return pos

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
