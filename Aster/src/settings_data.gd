# settings_data.gd
class_name SettingsData
extends Resource

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var recent_save: String = ""

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://settings.tres"

static func read(path: String = PATH) -> SettingsData:
	if not ResourceLoader.exists(path): return null
	else: return ResourceLoader.load(path)

static func write(data: SettingsData, path: String = PATH) -> Error:
	assert(data)
	DirAccess.remove_absolute(path)
	return ResourceSaver.save(data, path)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
