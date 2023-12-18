# main.gd
class_name Main
extends StateMachine

@onready var splash_state: MainSplashState = $MainSplashState
@onready var title_state: MainTitleState = $MainTitleState
@onready var world_state: MainWorldState = $MainWorldState
