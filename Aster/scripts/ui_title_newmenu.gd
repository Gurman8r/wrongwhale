# ui_title_newmenu.gd
class_name UI_TitleNewMenu
extends Control

const world_default = preload("res://resources/data/world_default.tres")
const player_default = preload("res://resources/data/player_default.tres")

@onready var world_data: WorldData = world_default.duplicate()
@onready var player_data: PlayerData = player_default.duplicate()

#@export var world_guid = "Save_New"
#@export var world_name = "New Save"
#@export var player_guid = "Player_New"
#@export var player_name = "New Player"
#@export var player_cell = "WorldCell0"
#@export var player_position = Vector3.ZERO
#@export var player_direction = Vector3.FORWARD

func _on_button_play_pressed():
	#world_data.version = world_version
	#world_data.guid = world_guid
	#world_data.name = world_name
	#world_data.actor_data = {}
	#world_data.player_data = {}
	#world_data.player_data[player_guid] = PlayerData.new()
	#var player_data: PlayerData = world_data.player_data[player_guid]
	#player_data.guid = player_guid
	#player_data.name = player_name
	#player_data.cell_name = player_cell
	#player_data.position = player_position
	#player_data.direction = player_direction
	Ref.main.load_game(world_data)

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
