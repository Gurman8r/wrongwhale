# ui_title_options.gd
class_name UI_TitleOptions
extends PanelContainer

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

func _ready():
	back_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.main)

func _on_button_back_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.main
