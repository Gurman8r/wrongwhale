# state_machine.gd
class_name StateMachine
extends Node

@export var state: State

func _ready():
	if state is State: state._enter_state()

func change_state(value: State):
	if state is State: state._exit_state()
	if value is State: value._enter_state()
	state = value
