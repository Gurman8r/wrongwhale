# debug_overlay.gd
class_name DebugOverlay
extends Control

@onready var label: Label = $MarginContainer/Label

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func toggle() -> void:
	visible = !visible

func add_line(text: String) -> DebugOverlay:
	label.text += text
	return self
