# debug.gd
# Debug
extends Node

# ui
var interface: DebugInterface
var overlay: DebugOverlay

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = Utility.make(self, DebugInterface.PREFAB, "Interface")
	overlay = Utility.make(self, DebugOverlay.PREFAB, "Overlay")
	reset()

func reset() -> void:
	pass
