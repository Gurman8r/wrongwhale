# splash_system.gd
# autoload Splash
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const overlay_prefab = preload("res://assets/scenes/splash_overlay.tscn")

var canvas: CanvasLayer
var overlay: SplashOverlay

var timer: Timer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	canvas.hide()
	
	overlay = Utility.make_child(canvas, overlay_prefab.instantiate(), "Overlay")
	overlay.hide()
	
	timer = Utility.make_child(self, Timer.new(), "Timer")
	timer.one_shot = true
	timer.autostart = false

func play() -> void:
	assert(overlay.visible)
	finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
