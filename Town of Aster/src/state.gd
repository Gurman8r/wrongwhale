# state.gd
class_name State
extends Node

signal finished()

func _enter_state() -> void:
	print("enter: %s" % [name])

func _exit_state() -> void:
	print("exit: %s" % [name])
