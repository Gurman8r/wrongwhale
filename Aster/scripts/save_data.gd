# save_data.gd
class_name SaveData
extends Resource

const SAVE_GAME_PATH = "user://save0.tres"

@export var version: int = 1

@export var player_data: PlayerData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

func write() -> Error:
	return ResourceSaver.save(self, SAVE_GAME_PATH)

func read() -> Resource:
	return ResourceLoader.load(SAVE_GAME_PATH)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
