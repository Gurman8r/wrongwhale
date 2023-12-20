# debug_interface.gd
class_name DebugInterface
extends Control

func _init() -> void:
	mouse_filter = MOUSE_FILTER_PASS

func toggle() -> void:
	visible = !visible
