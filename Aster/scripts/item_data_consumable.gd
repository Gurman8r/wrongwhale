# item_data_consumable.gd
class_name ItemDataConsumable
extends ItemData

func use(target) -> void:
	print("%s consumed by %s" % [to_string(), target.to_string()])
