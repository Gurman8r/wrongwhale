# ui_debug.gd
class_name UI_Debug
extends Control

@onready var framerate: Label = $MarginContainer/VBoxContainer/Framerate

func _physics_process(_delta):
	framerate.text = "FPS: %3.3f" % [Engine.get_frames_per_second()]

func toggle() -> void:
	visible = not visible
