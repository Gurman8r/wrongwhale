# transition_controller.gd
# Transition
extends SystemController

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const overlay_prefab = preload("res://assets/scenes/transition_overlay.tscn")

var canvas: CanvasLayer
var overlay: TransitionOverlay

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	super._init()
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	overlay = Utility.make_child(canvas, overlay_prefab.instantiate(), "Overlay")
	
func _ready() -> void:
	canvas.show()
	overlay.show()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func play(animation: String) -> void:
	print("|* %s" % [animation])
	overlay.play(animation)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
