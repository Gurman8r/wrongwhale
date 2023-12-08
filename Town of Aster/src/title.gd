# title.gd
# Title
extends Node

const INTERFACE_PREFAB = preload("res://assets/scenes/title_interface.tscn")

var interface: TitleInterface

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = Utility.make(self, INTERFACE_PREFAB, "Interface")
	reset()

func reset() -> void:
	pass
