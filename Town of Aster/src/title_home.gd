# title_home.gd
class_name TitleHome
extends Control

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var mods_button = $MarginContainer/VBoxContainer/ModsButton
@onready var settings_button = $MarginContainer/VBoxContainer/SettingsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func():
		Title.interface.menu = Title.interface.world_loader)
	
	new_button.pressed.connect(func():
		Title.interface.menu = Title.interface.world_creator)
	
	mods_button.pressed.connect(func():
		Title.interface.menu = Title.interface.mods)
	
	settings_button.pressed.connect(func():
		Title.interface.menu = Title.interface.settings)
	
	quit_button.pressed.connect(func():
		Game.quit_to_desktop())
