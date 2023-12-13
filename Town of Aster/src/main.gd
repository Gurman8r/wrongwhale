# main.gd
class_name Main
extends StateMachine

@onready var splash_state: SplashState = $SplashState
@onready var title_state: TitleState = $TitleState
@onready var world_state: WorldState = $WorldState
