# splash_controller.gd
# Splash
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas: CanvasLayer
var overlay: SplashOverlay
var timer: Timer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas = Util.make(self, CanvasLayer.new(), "Canvas")
	overlay = Util.make(canvas, preload("res://assets/scenes/splash_overlay.tscn").instantiate(), "Overlay")
	timer = Util.make(self, Timer.new(), "Timer")
	timer.one_shot = true

func _ready():
	assert(canvas.visible)
	overlay.hide()

func play() -> void:
	assert(overlay.visible)
	finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
