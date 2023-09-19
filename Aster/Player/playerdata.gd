# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# playerdata.gd
extends Resource
class_name PlayerData

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@export var guid: String = "player_new"
@export var name: String = "New Player"
@export var items: Array[ItemData] = []

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

signal items_changed(indices: Array[int])

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func set_item(index: int, value: ItemData) -> ItemData:
	assert(index < items.size())
	var previous = items[index]
	items[index] = value
	items_changed.emit([index])
	return previous

func swap_items(source: int, target: int):
	var count = items.size()
	assert(source < count)
	assert(target < count)
	if (source == target): return
	var source_item = items[source]
	var target_item = items[target]
	items[target] = source_item
	items[source] = target_item
	items_changed.emit([source, target])

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
