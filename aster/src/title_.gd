# title_.gd
# Title
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas_layer: CanvasLayer
var gui: TitleInterface

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer = Util.make(self, CanvasLayer.new(), "CanvasLayer")
	gui = Util.make(canvas_layer, Prefabs.TITLE_INTERFACE.instantiate(), "Interface")
	
func _ready() -> void:
	assert(canvas_layer.visible)
	gui.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
