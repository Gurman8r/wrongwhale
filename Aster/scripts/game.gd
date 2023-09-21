# game.gd
class_name Game
extends Node

enum { LEFT, RIGHT, UP, DOWN, }

enum { STATE_MENU, STATE_GAME, }

func _init():
	assert(Global.game == null)
	Global.game = self
