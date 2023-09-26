# ui_hud.gd
class_name UI_HUD
extends Control

@onready var hotbar: Hotbar = $ItemHotbar
@onready var interact_label: Label = $InteractLabel

func _ready():
	interact_label.text = ""
