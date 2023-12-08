# game.gd
# Game
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const DATA_DIR := "user://data"
const MODS_DIR := "user://mods"
const SAVES_DIR := "user://saves"

enum { SPLASH_STATE, TITLE_STATE, WORLD_STATE }
const STATES := [ "SplashState", "TitleState", "WorldState" ]
@onready var main: StateMachine = $"../Main"
@onready var splash_state: SplashState = $"../Main/SplashState"
@onready var title_state: TitleState = $"../Main/TitleState"
@onready var world_state: WorldState = $"../Main/WorldState"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# create file structure
	DirAccess.make_dir_absolute(DATA_DIR)
	DirAccess.make_dir_absolute(MODS_DIR)
	DirAccess.make_dir_absolute(SAVES_DIR)

func _ready() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
