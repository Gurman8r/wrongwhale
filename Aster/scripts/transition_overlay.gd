# transition_overlay.gd
class_name TransitionOverlay
extends Control

signal finished()

@onready var dissolve_rect = $DissolveRect
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("RESET")

func play_fadeout():
	animation_player.play("dissolve")
	await animation_player.animation_finished
	finished.emit()

func play_fadein():
	animation_player.play_backwards("dissolve")
	await animation_player.animation_finished
	finished.emit()
