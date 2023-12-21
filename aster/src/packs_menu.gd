# packs_menu.gd
class_name PacksMenu
extends PanelContainer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	reset()
	
	back_button.pressed.connect(func():
		Title.interface.menu = Title.interface.home)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
