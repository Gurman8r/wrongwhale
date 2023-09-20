# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# player.gd
class_name Player
extends CharacterBody3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera: Camera3D = $Camera
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var mesh_instance: MeshInstance3D = $MeshInstance
@onready var raycast: RayCast3D = $RayCast

@export var data: PlayerData
@export var entity: Entity
@export var inventory: Inventory

@export var walk_speed: float = 5.0
@export var run_speed: float = 7.5
var immobilized: bool = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(self.animation_player)
	assert(self.animation_tree)
	assert(self.camera)
	assert(self.collision_shape)
	assert(self.mesh_instance)
	assert(self.raycast)
	
	#entity.health_changed.connect(func (value: float): pass)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _process(_delta):
	#var menu_dir = Input.get_vector("menu_left", "menu_right", "menu_up", "menu_down")
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var pan_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var sprint = Input.is_action_pressed("sprint")
	
	# movement
	var move_speed: float = self.walk_speed
	if sprint: move_speed = self.run_speed
	self.velocity = Vector3(move_dir.x, 0, move_dir.y) * move_speed
	if !self.immobilized: self.move_and_slide()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _physics_process(delta : float) -> void:
	if self.raycast.is_colliding():
		var collider = self.raycast.get_collider()
		var point = self.raycast.get_collision_point()
		var normal = self.raycast.get_collision_normal()
		if Input.is_action_just_released("interact"):
			print("HIT: "+collider.to_string())
		
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
