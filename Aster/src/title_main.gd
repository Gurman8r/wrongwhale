# title_main.gd
class_name TitleMain
extends PanelContainer

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var options_button = $MarginContainer/VBoxContainer/OptionsButton
@onready var mods_button = $MarginContainer/VBoxContainer/ModsButton
@onready var credits_button = $MarginContainer/VBoxContainer/CreditsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func(): G.ui.title.current_menu = G.ui.title.world_loader)
	new_button.pressed.connect(func(): G.ui.title.current_menu = G.ui.title.world_creator)
	options_button.pressed.connect(func(): G.ui.title.current_menu = G.ui.title.options)
	mods_button.pressed.connect(func(): G.ui.title.current_menu = G.ui.title.mods)
	credits_button.pressed.connect(func(): G.ui.title.current_menu = G.ui.title.credits)
	quit_button.pressed.connect(func(): G.main.quit_to_desktop())
