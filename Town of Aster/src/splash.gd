# splash.gd
# Splash
extends Node

var interface: SplashInterface

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = SplashInterface.PREFAB.instantiate()
	add_child(interface)
	interface.name = "Interface"
	reset()

func reset() -> void:
	pass
