# cell.gd
class_name Cell
extends Node3D

func _notification(what):
	match what:
		NOTIFICATION_READY:
			assert(Global.world.register_cell(self))
		NOTIFICATION_PREDELETE:
			assert(Global.world.unregister_cell(self))
