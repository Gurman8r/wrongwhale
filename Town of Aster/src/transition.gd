# transition.gd
# Transition
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var overlay: TransitionOverlay
const overlay_prefab = preload("res://assets/scenes/transition_overlay.tscn")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	overlay = Utility.make_child(self, overlay_prefab.instantiate(), "Overlay")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func play(animation: String) -> void:
	overlay.play(animation)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
