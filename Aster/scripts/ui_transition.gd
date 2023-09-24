# ui_transition.gd
class_name UI_Transition
extends Control

signal finished()

@onready var dissolve_rect = $DissolveRect
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	reset()

func reset() -> void:
	animation_player.play("RESET")

func fadeout() -> void:
	animation_player.play("dissolve")
	await animation_player.animation_finished
	finished.emit()

func fadein() -> void:
	animation_player.play_backwards("dissolve")
	await animation_player.animation_finished
	finished.emit()
