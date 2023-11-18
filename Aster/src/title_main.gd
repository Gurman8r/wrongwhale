# title_main.gd
class_name TitleMain
extends PanelContainer

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var options_button = $MarginContainer/VBoxContainer/OptionsButton
@onready var mods_button = $MarginContainer/VBoxContainer/ModsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.world_loader)
	new_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.world_creator)
	options_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.option_interface)
	mods_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.mod_interface)
	quit_button.pressed.connect(func(): Ref.main.quit_to_desktop())
