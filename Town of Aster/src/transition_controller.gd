# transition_controller.gd
# Transition
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas: CanvasLayer
var overlay: TransitionOverlay

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas = Util.make(self, CanvasLayer.new(), "Canvas")
	overlay = Util.make(canvas, preload("res://assets/scenes/transition_overlay.tscn").instantiate(), "Overlay")

func _ready() -> void:
	assert(canvas.visible)
	overlay.show()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func play(animation: String) -> void:
	Debug.puts(" | %s" % [animation])
	overlay.play(animation)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
