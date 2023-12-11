# settings_data.gd
class_name SettingsData
extends Resource

@export var skip_splash: bool = false

@export var recent_save: String = ""

@export var window_mode: int = DisplayServer.WINDOW_MODE_WINDOWED
@export var window_size: Vector2i = Vector2i(1280, 720)
@export var window_vsync: int = DisplayServer.VSYNC_ENABLED
