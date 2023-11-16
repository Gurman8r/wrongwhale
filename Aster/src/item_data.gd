# item_data.gd
class_name ItemData
extends Resource

enum {
	PRIMARY_BEGIN, PRIMARY, PRIMARY_END,
	SECONDARY_BEGIN, SECONDARY, SECONDARY_END,
}

signal used()

@export var name: String = "New Item"
@export_multiline var description: String = ""
@export_range(1, ItemStack.MAX) var max_stack: int = ItemStack.MAX
@export var texture: Texture
@export var durability: float = -1

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func use(_owner: InventoryData, _index: int, _mode: int, _target: Node) -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
