# title_controller.gd
# Title
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var interface: TitleInterface
var canvas: CanvasLayer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas = Util.make_as_child(self, CanvasLayer.new(), "Canvas")
	interface = Util.make_as_child(canvas, preload("res://assets/scenes/title_interface.tscn").instantiate(), "Interface")
	
func _ready() -> void:
	assert(canvas.visible)
	interface.hide()


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
