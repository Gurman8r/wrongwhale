# title_home.gd
class_name TitleHome
extends Control

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var mods_button = $MarginContainer/VBoxContainer/ModsButton
@onready var settings_button = $MarginContainer/VBoxContainer/SettingsButton
@onready var credits_button = $MarginContainer/VBoxContainer/CreditsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func():
		Title.interface.menu = Title.interface.world_loader)
	
	new_button.pressed.connect(func():
		Title.interface.menu = Title.interface.world_creator)
	
	settings_button.pressed.connect(func():
		Title.interface.menu = Title.interface.settings)
	
	mods_button.pressed.connect(func():
		Title.interface.menu = Title.interface.mods)
	
	credits_button.pressed.connect(func():
		Title.interface.menu = Title.interface.credits)
	
	quit_button.pressed.connect(func():
		Game.quit_to_desktop())
