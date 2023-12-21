# splash_.gd
# Splash
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas_layer: CanvasLayer
var hud: SplashOverlay
var timer: Timer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer = Util.make(self, CanvasLayer.new(), "CanvasLayer")
	hud = Util.make(canvas_layer, Prefabs.SPLASH_OVERLAY.instantiate(), "Overlay")
	timer = Util.make(self, Timer.new(), "Timer")
	timer.one_shot = true

func _ready():
	assert(canvas_layer.visible)
	hud.hide()

func play() -> void:
	assert(hud.visible)
	finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
