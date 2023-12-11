# title.gd
# Title
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const interface_prefab = preload("res://assets/scenes/title_interface.tscn")
var interface: TitleInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	interface = Utility.make_child(self, interface_prefab.instantiate(), "Interface")
	interface.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
