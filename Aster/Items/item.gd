# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# item.gd
extends MeshInstance3D
class_name Item

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

@export var data: ItemData

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _ready():
	self.mesh = self.data.mesh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
