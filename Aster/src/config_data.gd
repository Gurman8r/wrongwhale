# config_data.gd
class_name ConfigData
extends Resource

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var recent_save: String = ""

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#region RW

const PATH := "user://config.tres"

static func read(path: String = PATH) -> Resource:
	if not ResourceLoader.exists(path): return null
	else: return ResourceLoader.load(path)

static func write(data: ConfigData, path: String = PATH) -> Error:
	assert(data)
	DirAccess.remove_absolute(path)
	return ResourceSaver.save(data, path)

#endregion

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
