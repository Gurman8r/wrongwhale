# state.gd
class_name State
extends Node

signal started()
signal finished()

func _ready() -> void:
	Utility.set_active(self, false)

func _enter_state() -> void:
	print(">> %s" % [name])
	Utility.set_active(self, true)
	started.emit()

func _exit_state() -> void:
	print("<< %s" % [name])
	Utility.set_active(self, false)
	finished.emit()
