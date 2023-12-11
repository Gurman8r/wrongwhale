# splash.gd
# Splash
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal finished()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const overlay_prefab = preload("res://assets/scenes/splash_overlay.tscn")
var overlay: SplashOverlay

var timer: Timer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	overlay = Utility.make_child(self, overlay_prefab.instantiate(), "Overlay")
	overlay.hide()
	
	timer = Utility.make_child(self, Timer.new(), "Timer")
	timer.one_shot = true
	timer.autostart = false

func play() -> void:
	assert(overlay.visible)
	finished.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
