# ui_title_main.gd
class_name UI_TitleMain
extends PanelContainer

@onready var load_button = $MarginContainer/VBoxContainer/LoadButton
@onready var new_button = $MarginContainer/VBoxContainer/NewButton
@onready var options_button = $MarginContainer/VBoxContainer/OptionsButton
@onready var mods_button = $MarginContainer/VBoxContainer/ModsButton
@onready var quit_button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	load_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.loadgame)
	new_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.newgame)
	options_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.options)
	mods_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.mods)
	quit_button.pressed.connect(func(): Ref.main.quit_to_desktop())
