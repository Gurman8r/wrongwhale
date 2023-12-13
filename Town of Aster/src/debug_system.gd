# debug_system.gd
# autoload Debug
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const interface_prefab = preload("res://assets/scenes/debug_interface.tscn")
const overlay_prefab = preload("res://assets/scenes/debug_overlay.tscn")

var interface: DebugInterface
var canvas: CanvasLayer
var overlay: DebugOverlay

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	canvas.hide()
	
	interface = Utility.make_child(canvas, interface_prefab.instantiate(), "Interface")
	interface.hide()
	
	overlay = Utility.make_child(canvas, overlay_prefab.instantiate(), "Overlay")
	overlay.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
