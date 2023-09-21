# player.gd
class_name Player
extends CharacterBody3D

@export var data: PlayerData

@export var walk_speed: float = 5
@export var run_speed: float = 10
@export var pan_speed: Vector2 = Vector2(0.005, 0.005)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera: Camera3D = $Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var interact_ray: InteractRay = $InteractRay
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

signal toggle_inventory()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init():
	assert(!Global.players.has(self))
	Global.players.append(self)
	if !Global.player && Global.players.size() == 1:
		Global.player = self
	
func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			assert(Global.players.has(self))
			Global.players.erase(self)
			if Global.player == self:
				Global.player = null

func _ready():
	assert(animation_player, "animation_player is invalid: "+self.to_string())
	assert(animation_tree, "animation_tree is invalid: "+self.to_string())
	assert(camera, "camera is invalid: "+self.to_string())
	assert(collision_shape, "collision_shape is invalid: "+self.to_string())
	assert(interact_ray, "interact_ray is invalid: "+self.to_string())
	assert(mesh_instance, "mesh_instance is invalid: "+self.to_string())

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _unhandled_input(event):
#	if event is InputEventMouseMotion:
#		rotate_y(-event.relative.x * pan_speed.x)
#		camera.rotate_x(-event.relative.y * pan_speed.y)
#		camera.rotation.x = clamp(camera.rotation.x, -PI/4, PI/4)
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

func _physics_process(delta : float) -> void:
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var pan_dir: Vector2 = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var sprint_pressed: bool = Input.is_action_pressed("sprint")
	var interact_pressed: bool = Input.is_action_just_released("interact")
	
	var move_speed: float = walk_speed
	if sprint_pressed: move_speed = run_speed
	var move_vec = Vector3(move_dir.x, 0, move_dir.y) * move_speed * delta
	if move_vec != Vector3.ZERO:
		var collision = move_and_collide(move_vec)
	
#	if interact_ray.is_colliding():
#		var detected = interact_ray.get_collider()
#		if detected is Interactable:
#			#prompt.text = detected.get_prompt()
#			if Input.is_action_just_pressed(detected.prompt_action):
#				detected.interact(self)
		
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
