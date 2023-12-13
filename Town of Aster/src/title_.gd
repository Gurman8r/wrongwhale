# title_.gd
# Title
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var interface: TitleInterface
var canvas: CanvasLayer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	canvas = Util.make(self, CanvasLayer.new(), "Canvas")
	interface = Util.make(canvas, preload("res://assets/scenes/title_interface.tscn").instantiate(), "Interface")
	
func _ready() -> void:
	assert(canvas.visible)
	interface.hide()


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
