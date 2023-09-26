# item_data.gd
class_name ItemData
extends Resource

@export var version: int = 1
@export var name: String = "New Item"
@export_multiline var description: String = ""
@export_range(1, ItemStack.MAX) var max_stack: int = ItemStack.MAX
@export var texture: Texture

func use(_target) -> void:
	pass
