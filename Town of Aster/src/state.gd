# state.gd
class_name State
extends Node

signal entered()
signal exited()

func _ready() -> void:
	entered.connect(func(): print(">> %s" % [name]))
	exited.connect(func(): print("<< %s" % [name]))
	Utility.set_active(self, false)

func _enter_state() -> void:
	Utility.set_active(self, true)
	entered.emit()

func _exit_state() -> void:
	exited.emit()
	Utility.set_active(self, false)
