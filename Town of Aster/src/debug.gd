# debug.gd
# Debug
extends Node

# prefabs
const INTERFACE_PREFAB = preload("res://assets/scenes/debug_interface.tscn")
const OVERLAY_PREFAB = preload("res://assets/scenes/debug_overlay.tscn")

# ui
var interface: DebugInterface
var overlay: DebugOverlay

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = Utility.make(self, INTERFACE_PREFAB, "Interface")
	overlay = Utility.make(self, OVERLAY_PREFAB, "Overlay")
	reset()

func reset() -> void:
	pass
