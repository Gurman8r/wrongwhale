# item_data.gd
class_name ItemData
extends Resource

const MAX_STACK: int = 99

@export var name: String = ""
@export_multiline var description: String = ""
@export_range(1, MAX_STACK) var max_stack: int = MAX_STACK
@export var texture: Texture

func use(target) -> void:
	pass
