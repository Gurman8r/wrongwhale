# interactable.gd
class_name Interactable
extends StaticBody3D

signal interacted(other)

@export var prompt_message = "Interact"
@export var prompt_action = "interact"

func get_prompt() -> String:
	if get_tree().paused: return ""
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = action.as_text()
	return prompt_message + "\n[" + key_name + "]"

func interact(other) -> void:
	interacted.emit(other)
