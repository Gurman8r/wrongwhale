# debug.gd
# Debug
extends Node

var interface: DebugInterface

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = DebugInterface.PREFAB.instantiate()
	add_child(interface)
	interface.name = "Interface"
	reset()

func reset() -> void:
	pass
