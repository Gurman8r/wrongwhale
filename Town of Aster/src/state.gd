# state.gd
class_name State
extends Node

signal started()
signal finished()

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	print("enter: %s" % [name])
	set_physics_process(true)
	started.emit()

func _exit_state() -> void:
	print("exit: %s" % [name])
	set_physics_process(false)
	finished.emit()
