# debug_controller.gd
# Debug
extends SystemController

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const overlay_prefab = preload("res://assets/scenes/debug_overlay.tscn")
const interface_prefab = preload("res://assets/scenes/debug_interface.tscn")

var canvas: CanvasLayer
var overlay: DebugOverlay
var interface: DebugInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	super._init()
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	overlay = Utility.make_child(canvas, overlay_prefab.instantiate(), "Overlay")
	interface = Utility.make_child(canvas, interface_prefab.instantiate(), "Interface")

func _ready() -> void:
	canvas.hide()
	overlay.hide()
	interface.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
