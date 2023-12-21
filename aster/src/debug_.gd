# debug_.gd
# Debug
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas_layer: CanvasLayer
var overlay: DebugOverlay
var interface: DebugInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer = Util.make(self, CanvasLayer.new(), "CanvasLayer")
	overlay = Util.make(canvas_layer, Prefabs.DEBUG_OVERLAY.instantiate(), "Overlay")
	interface = Util.make(canvas_layer, Prefabs.DEBUG_INTERFACE.instantiate(), "Interface")

func _ready() -> void:
	assert(canvas_layer.visible)
	overlay.visible = Game.is_debug()
	interface.hide()

func _unhandled_input(_event) -> void:
	#if Input.is_action_just_pressed("toggle_console"): interface.toggle()
	if Input.is_action_just_pressed("toggle_debug"): overlay.toggle()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
