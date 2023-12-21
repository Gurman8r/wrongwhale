# credits_menu.gd
class_name CreditsMenu
extends PanelContainer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	reset()
	
	back_button.pressed.connect(func():
		Title.gui.menu = Title.gui.home)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

