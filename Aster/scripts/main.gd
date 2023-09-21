# main.gd
class_name Main
extends Node

enum State {
	NONE,
	TITLE_SPLASH,
	TITLE_MAIN,
	TITLE_LOAD,
	GAME_PLAYING,
	GAME_PAUSED,
}

@export var state: State = State.NONE

func _init():
	Game.main = self
