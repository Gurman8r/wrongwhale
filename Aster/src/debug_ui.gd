# debug_ui.gd
class_name DebugUI
extends Control

# OVERLAY
@onready var overlay: Control = $Overlay
@onready var framerate: Label = $Overlay/VBoxContainer/Framerate

# INTERFACE
@onready var interface: Control = $Interface

func _init() -> void:
	assert(Game.debug_ui == null)
	Game.debug_ui = self

func _physics_process(_delta):
	framerate.text = "FPS: %3.3f" % [Engine.get_frames_per_second()]

func toggle() -> void:
	visible = not visible
