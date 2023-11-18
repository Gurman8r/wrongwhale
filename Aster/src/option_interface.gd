# option_interface.gd
class_name OptionInterface
extends PanelContainer

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

@onready var window_mode_button = $MarginContainer/VBoxContainer/Video/MarginContainer/VBoxContainer/WindowMode/HBoxContainer/WindowModeButton
@onready var window_size_button = $MarginContainer/VBoxContainer/Video/MarginContainer/VBoxContainer/WindowSize/HBoxContainer/WindowSizeButton
@onready var graphics_vsync_button = $MarginContainer/VBoxContainer/Graphics/MarginContainer/VBoxContainer/Vsync/HBoxContainer/WindowVsyncButton

func _reset() -> void:
	pass

func _ready():
	_reset()
	back_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.main)
	
	graphics_vsync_button.pressed.connect(func():
		graphics_vsync_button.release_focus())
	
	window_mode_button.get_popup().add_item("Windowed", DisplayServer.WINDOW_MODE_WINDOWED)
	window_mode_button.get_popup().add_item("Fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
	window_mode_button.get_popup().index_pressed.connect(func(index: int):
		if index == DisplayServer.window_get_mode(): return
		window_mode_button.text = window_mode_button.get_popup().get_item_text(index)
		DisplayServer.window_set_mode(window_mode_button.get_popup().get_item_id(index))
		window_mode_button.release_focus())
	
	window_size_button.get_popup().add_item("640 x 480", 0)
	window_size_button.get_popup().add_item("1280 x 720", 1)
	window_size_button.get_popup().add_item("1600 x 900", 2)
	window_size_button.get_popup().add_item("1920 x 1080", 3)
	window_size_button.get_popup().index_pressed.connect(func(index: int):
		window_size_button.release_focus())
