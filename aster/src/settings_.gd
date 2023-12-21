# settings_.gd
# Settings
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	print("\nSETTINGS")
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		for section in config.get_sections():
			for key in config.get_section_keys(section):
				var value = config.get_value(section, key)
				var path = "%s/%s" % [section, key]
				ProjectSettings.set_setting(path, value)
				print("%s/%s=%s" % [section, key, value])
	ProjectSettings.save_custom("user://override.cfg")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_setting(key: String, default = null): return ProjectSettings.get_setting(key, default)

func set_setting(key: String, value) -> void: ProjectSettings.set_setting(key, value)

func has_setting(key: String) -> bool: return ProjectSettings.has_setting(key)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
