# player.gd
class_name Player
extends Unit

@onready var camera: Camera3D = $Camera

@export var walk_speed: float = 5.0
@export var run_speed: float = 7.5
@export var inventory: Inventory

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _notification(what):
	match (what):
		NOTIFICATION_READY:
			assert(camera, "player camera not set")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _physics_process(_delta : float) -> void:
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var pan_dir: Vector2 = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var sprint_pressed: bool = Input.is_action_pressed("sprint")
	var interact_pressed: bool = Input.is_action_just_released("interact")
	
	var move_speed: float = walk_speed
	if sprint_pressed: move_speed = run_speed
	velocity = Vector3(move_dir.x, 0, move_dir.y) * move_speed
	move_and_slide()
	
	if interact_ray.is_colliding():
		var detected = interact_ray.get_collider()
		if detected is Interactable:
			#prompt.text = detected.get_prompt()
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(self)
		
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
