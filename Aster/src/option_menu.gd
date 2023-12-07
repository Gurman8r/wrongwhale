# option_menu.gd
class_name OptionMenu
extends PanelContainer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var back_button = $MarginContainer/VBoxContainer/BackButton

@onready var window_mode_button = $MarginContainer/VBoxContainer/Video/MarginContainer/VBoxContainer/WindowMode/HBoxContainer/WindowModeButton
@onready var window_size_button = $MarginContainer/VBoxContainer/Video/MarginContainer/VBoxContainer/WindowSize/HBoxContainer/WindowSizeButton
@onready var window_vsync_button = $MarginContainer/VBoxContainer/Video/MarginContainer/VBoxContainer/WindowVsync/HBoxContainer/WindowVsyncButton

var window_sizes: Array[Vector2i]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	_reset()
	
	back_button.pressed.connect(func(): Game.ui.title.current = Game.ui.title.home)
	
	#graphics_vsync_button.pressed.connect(func():
	#	graphics_vsync_button.release_focus())
	
	window_mode_button.get_popup().add_item("Windowed", DisplayServer.WINDOW_MODE_WINDOWED)
	window_mode_button.get_popup().add_item("Fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
	window_mode_button.get_popup().index_pressed.connect(func(index: int):
		var id = window_mode_button.get_popup().get_item_id(index)
		if id == DisplayServer.window_get_mode(): return
		window_mode_button.text = window_mode_button.get_popup().get_item_text(index)
		DisplayServer.window_set_mode(id)
		window_mode_button.release_focus())
	
	
	for i in range(0, window_sizes.size()):
		var window_size = window_sizes[i]
		window_size_button.get_popup().add_item("(%d, %d)" % [window_size.x, window_size.y], i)
	window_size_button.get_popup().index_pressed.connect(func(index: int):
		window_size_button.text = window_size_button.get_popup().get_item_text(index)
		DisplayServer.window_set_size(window_sizes[window_size_button.get_popup().get_item_id(index)])
		window_size_button.release_focus())
	
	window_vsync_button.get_popup().add_item("Disabled", DisplayServer.VSYNC_DISABLED)
	window_vsync_button.get_popup().add_item("Enabled", DisplayServer.VSYNC_ENABLED)
	window_vsync_button.get_popup().add_item("Adaptive", DisplayServer.VSYNC_ADAPTIVE)
	window_vsync_button.get_popup().add_item("Mailbox", DisplayServer.VSYNC_MAILBOX)
	window_vsync_button.get_popup().index_pressed.connect(func(index: int):
		window_vsync_button.text = window_vsync_button.get_popup().get_item_text(index)
		DisplayServer.window_set_vsync_mode(window_vsync_button.get_popup().get_item_id(index))
		window_vsync_button.release_focus())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _reset() -> void:
	window_sizes = [ Vector2i(640, 480), Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080), ]
	
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_WINDOWED: window_mode_button.text = "Windowed"
		DisplayServer.WINDOW_MODE_FULLSCREEN: window_mode_button.text = "Fullscreen"
	
	match DisplayServer.window_get_vsync_mode():
		DisplayServer.VSYNC_DISABLED: window_vsync_button.text = "Disabled"
		DisplayServer.VSYNC_ENABLED: window_vsync_button.text = "Enabled"
		DisplayServer.VSYNC_ADAPTIVE: window_vsync_button.text = "Adaptive"
		DisplayServer.VSYNC_MAILBOX: window_vsync_button.text = "Mailbox"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
