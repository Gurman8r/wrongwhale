# ui_transition.gd
class_name UI_Transition
extends Control

signal finished()

@onready var dissolve_rect = $DissolveRect
@onready var animation_player = $AnimationPlayer

@onready var animations = {
	"RESET": reset,
	"fadeout": play_fadeout,
	"fadein": play_fadein,
}

func _ready():
	reset()

func play(animation: String):
	animations[animation].play()

func reset():
	animation_player.play("RESET")

func play_fadeout():
	animation_player.play("dissolve")
	await animation_player.animation_finished
	finished.emit()

func play_fadein():
	animation_player.play_backwards("dissolve")
	await animation_player.animation_finished
	finished.emit()
