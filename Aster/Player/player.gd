# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# player.gd
class_name Player
extends Entity

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@onready var camera: Camera3D = $Camera

@export var data: PlayerData
@export var inventory: Inventory

@export var walk_speed: float = 5.0
@export var run_speed: float = 7.5

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _physics_process(delta : float) -> void:
	#input
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var pan_dir: Vector2 = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var sprint_pressed: bool = Input.is_action_pressed("sprint")
	var interact_pressed: bool = Input.is_action_just_released("interact")
	
	# movement
	var move_speed: float = self.walk_speed
	if sprint_pressed: move_speed = self.run_speed
	self.velocity = Vector3(move_dir.x, 0, move_dir.y) * move_speed
	self.move_and_slide()
	
	# interact
	if self.interact_raycast.is_colliding():
		var collider = self.interact_raycast.get_collider()
		var point = self.interact_raycast.get_collision_point()
		var normal = self.interact_raycast.get_collision_normal()
		if interact_pressed:
			print("Interact: "+collider.to_string())
		
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
