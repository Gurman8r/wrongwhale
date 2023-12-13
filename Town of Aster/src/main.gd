# main.gd
class_name Main
extends StateMachine

enum { SPLASH_STATE, TITLE_STATE, WORLD_STATE }

const STATES := [ "SplashState", "TitleState", "WorldState" ]

@onready var splash_state = get_node(STATES[SPLASH_STATE])
@onready var title_state = get_node(STATES[TITLE_STATE])
@onready var world_state = get_node(STATES[WORLD_STATE])
