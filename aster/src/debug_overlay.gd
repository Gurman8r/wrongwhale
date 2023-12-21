# debug_overlay.gd
class_name DebugOverlay
extends Control

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var label: Label = $MarginContainer/Label

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var version: String = "%s (%s)" % [ProjectSettings.get_setting("application/config/version"), "debug" if Game.is_debug() else "release"]

var fps_value: float = 0.0
var fps_accum: float = 0.0
var fps_index: int = 0
var fps_times: Array[float] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Util.set_recursive(self, "mouse_filter", Control.MOUSE_FILTER_IGNORE)
	
	fps_times.resize(60)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _physics_process(delta) -> void:
	clear()
	
	puts("version: %s" % [version])
	
	fps_accum += delta - fps_times[fps_index];
	fps_times[fps_index] = delta;
	fps_index = (fps_index + 1) % fps_times.size();
	fps_value = (1.0 / (fps_accum / fps_times.size())) if (0.0 < fps_accum) else 1.79769e308
	puts("framerate: %.2ffps @ %fms" % [fps_value, delta])
	
	#puts("paused: %s" % ["true" if Game.paused else "false"])
	
	if Game.main.state: puts("state: %s (%s)" % [Game.main.state.name, "paused" if Game.paused else "unpaused"])
	
	var pd = Player.data
	var pc = Player.character
	if pd and pc:
		puts("cell: %s" % [pd.cell_name])
		puts("xyz: %1.1f, %1.1f, %1.1f" % [pc.global_transform.origin.x, pc.global_transform.origin.y, pc.global_transform.origin.z])

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func toggle() -> void:
	visible = !visible

func puts(text: String) -> void:
	label.text += text
	label.text += "\n"

func clear() -> void:
	label.text = ""

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
