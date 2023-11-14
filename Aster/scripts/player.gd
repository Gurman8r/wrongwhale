# player.gd
class_name Player
extends CharacterBody3D

signal toggle_inventory()
signal primary_action()
signal secondary_action()
signal hotbar_prev()
signal hotbar_next()
signal move(delta: float, direction: Vector3)
signal move_collide(body: KinematicCollision3D)

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

var item_index: int = 0 : set = set_item_index

var cell: WorldCell : get = get_cell

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.player = self

func _ready() -> void:
	primary_action.connect(_on_primary_action)
	secondary_action.connect(_on_secondary_action)
	hotbar_prev.connect(_on_hotbar_prev)
	hotbar_next.connect(_on_hotbar_next)
	move.connect(_on_move)
	move_collide.connect(_on_move_collide)
	
func _input(event) -> void:
	# camera
	if event is InputEventMouseMotion:
		camera_pivot_y.rotate_y(-event.relative.x * camera_speed.x)
		camera_pivot_x.rotate_x(-event.relative.y * camera_speed.y)
		camera_pivot_x.rotation.x = clamp( \
			camera_pivot_x.rotation.x, \
			deg_to_rad(camera_angle_min_degrees), \
			deg_to_rad(camera_angle_max_degrees))
	
	# actions
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			primary_action.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			secondary_action.emit()
		get_viewport().set_input_as_handled()

func _unhandled_input(_event) -> void:
	# movement
	move_input[LEFT] = Input.is_action_pressed("move_left")
	move_input[RIGHT] = Input.is_action_pressed("move_right")
	move_input[FORWARD] = Input.is_action_pressed("move_forward")
	move_input[BACKWARD] = Input.is_action_pressed("move_backward")
	
	# actions
	if Input.is_action_just_pressed("primary"): primary_action.emit()
	if Input.is_action_just_pressed("secondary"): secondary_action.emit()
	
	# inventory
	if Input.is_action_just_pressed("inventory"): toggle_inventory.emit()
	if Input.is_action_just_released("hotbar_prev"): hotbar_prev.emit()
	elif Input.is_action_just_released("hotbar_next"): hotbar_next.emit()
	for i in range(0, 10):
		if Input.is_action_just_pressed("hotbar_%d" % [i]):
			set_item_index(i - 1)
			break

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
		if body: move_collide.emit(body)
		
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

func load_data(world_data: WorldData):
	assert(world_data.player_data.has(data.guid))
	data.copy(world_data.player_data[data.guid])
	if get_cell().name != data.cell_name:
		get_cell().remove(self)
		Ref.world.set_cell(Ref.world.find_cell(data.cell_name))
		Ref.world.cell.add(self, data.position)
	else:
		global_transform.origin = data.position

func save_data(world_data: WorldData):
	data.position = global_transform.origin
	data.cell_name = get_cell().name
	world_data.player_data[data.guid] = data
	var pos: Vector3 = global_transform.origin + data.direction * drop_range
	pos.y = 0.5
	return pos

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_cell() -> WorldCell:
	return get_parent().get_parent() as WorldCell

func get_drop_position() -> Vector3:
	var pos: Vector3 = global_transform.origin + data.direction * drop_range
	pos.y = 0.5
	return pos

func get_held_item() -> ItemData:
	return data.inventory.get_item_data(item_index)

func set_item_index(value: int) -> void:
	Ref.ui.hud.hotbar.item_index = value
	item_index = Ref.ui.hud.hotbar.item_index

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_primary_action() -> void:
	print("primary")
	
func _on_secondary_action() -> void:
	print("secondary")
	data.inventory.use_stack(item_index, self)

func _on_hotbar_prev() -> void:
	set_item_index(item_index + 1)

func _on_hotbar_next() -> void:
	set_item_index(item_index - 1)

func _on_move(_delta: float, _direction: Vector3) -> void:
	pass
	
func _on_move_collide(_body: KinematicCollision3D) -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
