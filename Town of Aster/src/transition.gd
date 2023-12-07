# transition.gd
# Transition
extends Node

signal finished()

var overlay: TransitionOverlay

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	overlay = Utility.make(self, TransitionOverlay.PREFAB, "Overlay")
	reset()

func reset() -> void:
	overlay.reset()

func play(animation: String) -> void:
	overlay.play(animation)
