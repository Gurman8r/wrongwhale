# state_machine.gd
class_name StateMachine
extends Node

@export var state: State : set = set_state

func _ready() -> void:
	set_state(state)

func set_state(value: State):
	if state is State: state._exit_state()
	if value is State: value._enter_state()
	state = value
