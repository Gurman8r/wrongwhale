# ui_title_mods.gd
class_name UI_TitleMods
extends Control

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	pass

func _on_button_back_pressed() -> void:
	Ref.ui.title.current = Ref.ui.title.main
