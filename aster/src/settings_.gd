# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const SETTINGS := "user://settings.cfg"
const OVERRIDE := "user://override.cfg"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	print("\nLOADING_SETTINGS")
	if FileAccess.file_exists(OVERRIDE): load_config(OVERRIDE)
	else: ProjectSettings.save_custom(OVERRIDE)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_config(path: String) -> Error:
	var config = ConfigFile.new()
	var error = config.load(path)
	if error != OK: return error
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			var value = config.get_value(section, key)
			ProjectSettings.set_setting("%s/%s" % [section, key], value)
			print("%s/%s=%s" % [section, key, value])
	return OK

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_setting(key: String, default = null): return ProjectSettings.get_setting(key, default)

func set_setting(key: String, value) -> void: ProjectSettings.set_setting(key, value)

func has_setting(key: String) -> bool: return ProjectSettings.has_setting(key)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
