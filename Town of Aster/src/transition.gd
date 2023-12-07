# transition.gd
# Transition
extends Node

var interface: TransitionInterface

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	interface = TransitionInterface.PREFAB.instantiate()
	add_child(interface)
	interface.name = "Interface"
	reset()

func reset() -> void:
	interface.reset()

func play(animation: String) -> void:
	interface.play(animation)
