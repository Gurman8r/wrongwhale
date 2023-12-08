# transition.gd
# Transition
extends Node

signal finished()

# prefabs
const OVERLAY_PREFAB = preload("res://assets/scenes/transition_overlay.tscn")

var overlay: TransitionOverlay

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	overlay = Utility.make(self, OVERLAY_PREFAB, "Overlay")
	reset()

func reset() -> void:
	overlay.reset()

func play(animation: String) -> void:
	overlay.play(animation)
