# debug_controller.gd
# Debug
extends SystemController

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas: CanvasLayer
var overlay: DebugOverlay
var interface: DebugInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	super._init()
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	overlay = Utility.make_child(canvas, preload("res://assets/scenes/debug_overlay.tscn").instantiate(), "Overlay")
	interface = Utility.make_child(canvas, preload("res://assets/scenes/debug_interface.tscn").instantiate(), "Interface")

func _ready() -> void:
	assert(canvas.visible)
	overlay.hide()
	interface.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
