# main_state.gd
class_name MainState
extends State

func _ready() -> void:
	super._ready()
	entered.connect(func(): print("\n-> %s" % [name]))
	exited.connect(func(): print("<- %s" % [name]))
