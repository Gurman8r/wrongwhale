# debug_.gd
# Debug
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas_layer: CanvasLayer
var hud: DebugOverlay
var gui: DebugInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer = Util.make(self, CanvasLayer.new(), "CanvasLayer")
	hud = Util.make(canvas_layer, Prefabs.DEBUG_OVERLAY.instantiate(), "Overlay")
	gui = Util.make(canvas_layer, Prefabs.DEBUG_INTERFACE.instantiate(), "Interface")

func _ready() -> void:
	assert(canvas_layer.visible)
	hud.visible = Game.is_debug()
	gui.hide()

func _unhandled_input(_event) -> void:
	#if Input.is_action_just_pressed("toggle_console"): gui.toggle()
	if Input.is_action_just_pressed("toggle_debug"): hud.toggle()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
