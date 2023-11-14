# ui_title_newmenu.gd
class_name UI_TitleNewMenu
extends Control

@export var world_data: WorldData = WorldData.new()

func _on_button_play_pressed():
	var world_version = 1
	var world_guid = "Save_New"
	var world_name = "New Save"
	world_data.version = world_version
	world_data.guid = world_guid
	world_data.name = world_name
	world_data.player_data = {}
	
	var player_guid = "Player_New"
	var player_name = "New Player"
	world_data.player_data[player_guid] = PlayerData.new()
	var player_data = world_data.player_data[player_guid]
	player_data.guid = player_guid
	player_data.name = player_name
	player_data.cell_name = "WorldCell0"
	player_data.position = Vector3.ZERO
	player_data.direction = Vector3.FORWARD
	Ref.main.load_world(world_data)

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
