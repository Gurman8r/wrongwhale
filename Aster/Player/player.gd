# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# player.gd
extends CharacterBody3D
class_name Player

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# components
@onready var camera: Camera3D = $Camera
@onready var collider: CollisionShape3D = $Collider
@onready var mesh: MeshInstance3D = $Mesh

#data
@export var data: PlayerData

# movement
@export var walk_speed: float = 5.0
@export var run_speed: float = 7.5
var immobilized: bool = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	assert(self.camera, "Player camera not found")
	assert(self.collider, "Player collider not found")
	assert(self.mesh, "Player mesh not found")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _process(_delta):
	#var menu_dir = Input.get_vector("menu_left", "menu_right", "menu_up", "menu_down")
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var pan_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	var sprint = Input.is_action_pressed("sprint")
	
	# movement
	var move_speed: float = self.walk_speed
	if sprint: move_speed = self.run_speed
	velocity = Vector3(move_dir.x, 0, move_dir.y) * move_speed
	if !self.immobilized: self.move_and_slide()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
