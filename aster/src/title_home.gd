# title_home.gd
class_name TitleHome
extends Control

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var settings_button = $MarginContainer/VBoxContainer/SettingsButton
@onready var content_button = $MarginContainer/VBoxContainer/ContentButton
@onready var credits_button = $MarginContainer/VBoxContainer/CreditsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func():
		Title.interface.menu = Title.interface.world_loader)
	
	new_button.pressed.connect(func():
		Title.interface.menu = Title.interface.world_creator)
	
	settings_button.pressed.connect(func():
		Title.interface.menu = Title.interface.settings)
	
	content_button.pressed.connect(func():
		Title.interface.menu = Title.interface.content)
	
	credits_button.pressed.connect(func():
		Title.interface.menu = Title.interface.credits)
	
	quit_button.pressed.connect(func():
		Game.quit_to_desktop())
