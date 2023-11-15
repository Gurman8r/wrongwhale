# item_data.gd
class_name ItemData
extends Resource

signal used()

@export var name: String = "New Item"
@export_multiline var description: String = ""
@export_range(1, ItemStack.MAX) var max_stack: int = ItemStack.MAX
@export var texture: Texture
@export var durability: float = -1

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func use(_target) -> void:
	pass

func use_primary(_target) -> void:
	pass

func use_secondary(_target) -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
