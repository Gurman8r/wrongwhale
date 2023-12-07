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
	load_button.pressed.connect(func(): Game.ui.title.current = Game.ui.title.world_loader)
	new_button.pressed.connect(func(): Game.ui.title.current = Game.ui.title.world_creator)
	options_button.pressed.connect(func(): Game.ui.title.current = Game.ui.title.option_menu)
	mods_button.pressed.connect(func(): Game.ui.title.current = Game.ui.title.mod_menu)
	credits_button.pressed.connect(func(): Game.ui.title.current = Game.ui.title.credits_menu)
	quit_button.pressed.connect(func(): Game.quit_to_desktop())
