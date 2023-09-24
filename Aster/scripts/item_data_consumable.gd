# item_data_consumable.gd
class_name ItemDataConsumable
extends ItemData

func use(_target) -> void:
	print("consumed: %s" % [to_string()])
