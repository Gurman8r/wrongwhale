# debug_.gd
# Debug
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas: CanvasLayer
var overlay: DebugOverlay
var interface: DebugInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	canvas = Util.make(self, CanvasLayer.new(), "Canvas")
	overlay = Util.make(canvas, preload("res://assets/scenes/debug_overlay.tscn").instantiate(), "Overlay")
	interface = Util.make(canvas, preload("res://assets/scenes/debug_interface.tscn").instantiate(), "Interface")

func _ready() -> void:
	assert(canvas.visible)
	overlay.hide()
	interface.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func puts(value: String):
	if Settings.data.verbose_logging:
		print(value)
	return self

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #