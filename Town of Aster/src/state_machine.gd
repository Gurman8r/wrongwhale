# state_machine.gd
class_name StateMachine
extends Node

@export var state: State

func _ready():
	if state is State: state._enter_state()

func change_state(new_state: State) -> void:
	if state == new_state: return
	if state is State: state._exit_state()
	state = new_state
	if state is State: state._enter_state()
