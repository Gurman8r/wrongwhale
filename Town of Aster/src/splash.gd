# splash.gd
# Splash
extends Node

# ui
var overlay: SplashOverlay

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	overlay = Utility.make(self, SplashOverlay.PREFAB, "Overlay")
	
	reset()

func reset() -> void:
	pass
