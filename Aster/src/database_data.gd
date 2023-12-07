# database_data.gd
class_name DatabaseData
extends Resource

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var actors: Array[ActorData]
@export var items: Array[ItemData]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const PATH := "user://data/database.tres"

static func read(path: String = PATH) -> DatabaseData:
	if not ResourceLoader.exists(path): return null
	else: return ResourceLoader.load(path)

static func write(data: DatabaseData, path: String = PATH) -> Error:
	assert(data)
	DirAccess.remove_absolute(path)
	return ResourceSaver.save(data, path)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
