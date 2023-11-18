# opt_manager.gd
class_name OptManager
extends PanelContainer

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

func _ready():
	back_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.main)
