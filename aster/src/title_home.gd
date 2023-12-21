# title_home.gd
class_name TitleHome
extends Control

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var settings_button = $MarginContainer/VBoxContainer/SettingsButton
@onready var packs_button = $MarginContainer/VBoxContainer/PacksButton
@onready var credits_button = $MarginContainer/VBoxContainer/CreditsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func():
		Title.gui.menu = Title.gui.world_loader)
	
	new_button.pressed.connect(func():
		Title.gui.menu = Title.gui.world_creator)
	
	settings_button.pressed.connect(func():
		Title.gui.menu = Title.gui.settings)
	
	packs_button.pressed.connect(func():
		Title.gui.menu = Title.gui.packs)
	
	credits_button.pressed.connect(func():
		Title.gui.menu = Title.gui.credits)
	
	quit_button.pressed.connect(func():
		Game.quit_to_desktop())
