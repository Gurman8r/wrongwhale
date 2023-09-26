# save_data.gd
class_name WorldData
extends Resource

const SAVE_GAME_PATH = "user://save0.tres"

@export var version: int = 1
@export var guid: String = "Save_New"
@export var name: String = "New Save"

@export var player_data: Array[PlayerData]
@export var actor_data: Array[ActorData]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

func write() -> Error:
	return ResourceSaver.save(self, SAVE_GAME_PATH)

func read() -> Resource:
	return ResourceLoader.load(SAVE_GAME_PATH)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
