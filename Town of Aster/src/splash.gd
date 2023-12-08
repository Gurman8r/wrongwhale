# splash.gd
# Splash
extends Node

# prefabs
const OVERLAY_PREFAB = preload("res://assets/scenes/splash_overlay.tscn")

# ui
var overlay: SplashOverlay

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	overlay = Utility.make(self, OVERLAY_PREFAB, "Overlay")
	
	reset()

func reset() -> void:
	pass
