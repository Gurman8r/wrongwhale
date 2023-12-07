# title_home.gd
class_name TitleHome
extends PanelContainer

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var options_button = $MarginContainer/VBoxContainer/OptionsButton
@onready var mods_button = $MarginContainer/VBoxContainer/ModsButton
@onready var credits_button = $MarginContainer/VBoxContainer/CreditsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func(): Game.title_ui.current = Game.title_ui.world_loader)
	new_button.pressed.connect(func(): Game.title_ui.current = Game.title_ui.world_creator)
	options_button.pressed.connect(func(): Game.title_ui.current = Game.title_ui.option_menu)
	mods_button.pressed.connect(func(): Game.title_ui.current = Game.title_ui.mod_menu)
	credits_button.pressed.connect(func(): Game.title_ui.current = Game.title_ui.credits_menu)
	quit_button.pressed.connect(func(): Game.quit_to_desktop())
