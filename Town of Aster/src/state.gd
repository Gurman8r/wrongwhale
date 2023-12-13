# state.gd
class_name State
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal entered()
signal exited()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	entered.connect(func(): Debug.puts(">> %s" % [name]))
	exited.connect(func(): Debug.puts("<< %s\n" % [name]))
	Util.set_active(self, false)

func _enter_state() -> void:
	Util.set_active(self, true)
	entered.emit()

func _exit_state() -> void:
	exited.emit()
	Util.set_active(self, false)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
