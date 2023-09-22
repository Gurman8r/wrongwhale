# main.gd
class_name Main
extends Node

@onready var settings: Node = $Settings
@onready var world: World = $World
@onready var ui: UI = $UI

func _init() -> void:
	Game.main = self
