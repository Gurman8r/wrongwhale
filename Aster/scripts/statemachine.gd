# statemachine.gd
class_name StateMachine
extends Node

@export var state: State

func _ready() -> void:
	change_state(state)

func change_state(value: State) -> void:
	if state is State:
		state._exit_state()
	value._enter_state()
	state = value
