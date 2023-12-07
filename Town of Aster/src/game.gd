# game.gd
# Game
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

enum { SPLASH_SCREEN, TITLE_SCREEN, WORLD_SCREEN }

const SCREENS := [ "SplashScreen", "TitleScreen", "WorldScreen" ]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var main: StateMachine = get_parent().get_node("Main")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	#main.set_state(main.get_child(SPLASH_SCREEN))
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
