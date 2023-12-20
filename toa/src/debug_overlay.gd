# debug_overlay.gd
class_name DebugOverlay
extends Control

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var label: Label = $MarginContainer/Label

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var version: String = ProjectSettings.get_setting("application/config/version")
@onready var debug_str: String = Util.btos(Game.is_debug(), "debug", "release")

var fps_value: float = 0.0
var fps_accum: float = 0.0
var fps_index: int = 0
var fps_times: Array[float] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Util.set_recursive(self, "mouse_filter", Control.MOUSE_FILTER_IGNORE)
	
	fps_times.resize(120)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _physics_process(delta) -> void:
	clear()
	
	append("version: %s (%s)" % [version, debug_str])
	
	var state_name = ""
	if Game.main.state: state_name = Game.main.state.name
	append("state: %s" % [state_name])
	
	append("paused: %s" % [Util.btos(Game.paused)])
	
	fps_accum += delta - fps_times[fps_index];
	fps_times[fps_index] = delta;
	fps_index = (fps_index + 1) % fps_times.size();
	if 0.0 < fps_accum: fps_value = (1.0 / (fps_accum / fps_times.size()))
	else: fps_value = 1.79769e308
	append("fps: %4.3f" % [fps_value])
	
	var pd = Player.data
	var pc = Player.character
	if pd and pc:
		append("cell: %s" % [pd.cell_name])
		append("xyz: %1.1f, %1.1f, %1.1f" % [
			pc.global_transform.origin.x,
			pc.global_transform.origin.y,
			pc.global_transform.origin.z])

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func toggle() -> void:
	visible = !visible

func append(text: String) -> void:
	label.text += text
	label.text += "\n"

func clear() -> void:
	label.text = ""

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
