# title_system.gd
# autoload Title
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const interface_prefab = preload("res://assets/scenes/title_interface.tscn")

var interface: TitleInterface
var canvas: CanvasLayer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	interface = Utility.make_child(canvas, interface_prefab.instantiate(), "Interface")
	
func _ready() -> void:
	canvas.hide()
	interface.hide()


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
