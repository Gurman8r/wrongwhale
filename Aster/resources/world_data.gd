# save_data.gd
class_name WorldData
extends Resource

const SAVE_GAME_PATH = "user://save0.tres"

@export var version: int = 1
@export var guid: String = "Save_New"
@export var name: String = "New Save"
@export var path: String = "user://save0.tres"

@export var actor_data = {}
@export var player_data = {}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func write(world_data: WorldData) -> Error:
	return ResourceSaver.save(world_data, SAVE_GAME_PATH)

static func read() -> Resource:
	return ResourceLoader.load(SAVE_GAME_PATH)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
