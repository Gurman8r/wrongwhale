# transition_overlay.gd
class_name TransitionOverlay
extends Control

signal halfway()
signal finished()

@onready var dissolve_rect = $DissolveRect
@onready var animation_player = $AnimationPlayer

func play_fadeout():
	animation_player.play("dissolve")
	await animation_player.animation_finished
	finished.emit()

func play_fadein():
	animation_player.play_backwards("dissolve")
	await animation_player.animation_finished
	finished.emit()
