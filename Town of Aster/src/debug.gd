# debug.gd
# Debug
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const interface_prefab = preload("res://assets/scenes/debug_interface.tscn")
const overlay_prefab = preload("res://assets/scenes/debug_overlay.tscn")

var interface: DebugInterface
var overlay: DebugOverlay

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	interface = Utility.make_child(self, interface_prefab.instantiate(), "Interface")
	interface.hide()
	
	overlay = Utility.make_child(self, overlay_prefab.instantiate(), "Overlay")
	overlay.hide()
	
	reset()

func reset() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
