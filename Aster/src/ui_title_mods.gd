# ui_title_mods.gd
class_name UI_TitleMods
extends PanelContainer

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

func _ready():
	back_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.main)
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	pass

func _on_button_back_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.main
