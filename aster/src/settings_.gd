# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	print("\nLOADING_SETTINGS")
	load_config("user://settings.cfg")
	ProjectSettings.save_custom("user://override.cfg")

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
