# splash_controller.gd
# Splash
extends SystemController

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const overlay_prefab = preload("res://assets/scenes/splash_overlay.tscn")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas: CanvasLayer
var overlay: SplashOverlay
var timer: Timer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	super._init()
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	overlay = Utility.make_child(canvas, overlay_prefab.instantiate(), "Overlay")
	timer = Utility.make_child(self, Timer.new(), "Timer")
	timer.one_shot = true

func _ready():
	assert(canvas.visible)
	overlay.hide()

func play() -> void:
	assert(overlay.visible)
	finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
