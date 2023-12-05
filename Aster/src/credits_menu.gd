# credits_menu.gd
class_name CreditsMenu
extends PanelContainer

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

func _ready():
	back_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.main)
