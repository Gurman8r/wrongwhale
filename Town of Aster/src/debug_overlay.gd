# debug_overlay.gd
class_name DebugOverlay
extends Control

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var label: Label = $MarginContainer/Label

var fps_value: float
var fps_accum: float
var fps_index: int
var fps_times: Array[float] = []

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Util.set_recursive(self, "mouse_filter", Control.MOUSE_FILTER_IGNORE)
	
	fps_times.resize(120)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _physics_process(delta) -> void:
	clear()
	
	append("Paused: %d" % [int(Game.paused)])
	
	fps_accum += delta - fps_times[fps_index];
	fps_times[fps_index] = delta;
	fps_index = (fps_index + 1) % fps_times.size();
	if 0.0 < fps_accum: fps_value = (1.0 / (fps_accum / fps_times.size()))
	else: fps_value = 1.79769e308
	append("FPS: %4.3f" % [fps_value])
	
	var pd = Player.data
	var pc = Player.character
	if pd and pc:
		append("XYZ: %1.1f %1.1f %1.1f" % [
			pc.global_transform.origin.x,
			pc.global_transform.origin.y,
			pc.global_transform.origin.z])
		append("Cell: %s" % [pd.cell_name])

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func toggle() -> void:
	visible = !visible

func append(text: String) -> void:
	label.text += text
	label.text += "\n"

func clear() -> void:
	label.text = ""

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
