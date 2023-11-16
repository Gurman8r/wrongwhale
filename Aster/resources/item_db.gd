# item_db.gd
class_name ItemDB
extends Resource

@export var items: Dictionary = {}

func get_item(guid: String) -> ItemData:
	return items[guid]
