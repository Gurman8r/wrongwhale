# transition_.gd
# Transition
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas_layer: CanvasLayer
var hud: TransitionOverlay

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer = Util.make(self, CanvasLayer.new(), "CanvasLayer")
	hud = Util.make(canvas_layer, Prefabs.TRANSITION_OVERLAY.instantiate(), "Overlay")

func _ready() -> void:
	assert(canvas_layer.visible)
	hud.show()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func play(animation: String) -> void:
	print("+| %s" % [animation])
	hud.play(animation)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
