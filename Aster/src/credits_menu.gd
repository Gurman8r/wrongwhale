# credits_menu.gd
class_name CreditsMenu
extends PanelContainer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

var credits_text: String

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	reset()
	
	back_button.pressed.connect(func():
		Game.title_ui.current = Game.title_ui.home)

func reset() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
