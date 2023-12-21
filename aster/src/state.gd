# state.gd
class_name State
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal entered()
signal exited()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	Util.set_active(self, false)

func _enter_state() -> void:
	Util.set_active(self, true)
	entered.emit()

func _exit_state() -> void:
	Util.set_active(self, false)
	exited.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
