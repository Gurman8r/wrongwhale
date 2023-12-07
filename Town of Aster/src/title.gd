# title.gd
# Title
extends Node

var interface: TitleInterface

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = TitleInterface.PREFAB.instantiate()
	add_child(interface)
	interface.name = "Interface"
	reset()

func reset() -> void:
	pass
