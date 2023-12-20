# main_state.gd
class_name MainState
extends State

func _ready() -> void:
	super._ready()
	entered.connect(func(): Debug.puts("-> %s" % [name]))
	exited.connect(func(): Debug.puts("<- %s\n" % [name]))
