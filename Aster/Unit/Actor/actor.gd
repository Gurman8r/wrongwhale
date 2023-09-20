# actor.gd
class_name Actor
extends Unit

@export var inventory: Inventory

func _notification(what):
	match (what):
		NOTIFICATION_READY:
			pass
