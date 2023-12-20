# debug_.gd
# Debug
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas_layer: CanvasLayer
var overlay: DebugOverlay
var interface: DebugInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	canvas_layer = Util.make(self, CanvasLayer.new(), "CanvasLayer")
	overlay = Util.make(canvas_layer, Prefabs.DEBUG_OVERLAY.instantiate(), "Overlay")
	interface = Util.make(canvas_layer, Prefabs.DEBUG_INTERFACE.instantiate(), "Interface")

func _ready() -> void:
	assert(canvas_layer.visible)
	overlay.hide()
	interface.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func puts(value: String):
	if Settings.data.verbose_logging:
		print(value)
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
