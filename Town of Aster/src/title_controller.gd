# title_controller.gd
# Title
extends SystemController

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var interface: TitleInterface
var canvas: CanvasLayer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	super._init()
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	interface = Utility.make_child(canvas, preload("res://assets/scenes/title_interface.tscn").instantiate(), "Interface")
	
func _ready() -> void:
	assert(canvas.visible)
	interface.hide()


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
