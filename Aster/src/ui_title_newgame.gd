# ui_title_newgame.gd
class_name UI_TitleNewGame
extends Control

var world_data: WorldData
var player_data: PlayerData

func _on_button_play_pressed():
	world_data = WorldData.new()
	world_data.guid = "World_New"
	world_data.name = "New World"
	world_data.index = 0
	
	player_data = PlayerData.new()
	player_data.guid = "Player_New"
	player_data.name = "New Player"
	player_data.index = 0
	player_data.position = Vector3.ZERO
	player_data.direction = Vector3.FORWARD
	player_data.cell_name = "WorldCell0"
	player_data.inventory.stacks.resize(30)
	player_data.equip.stacks.resize(1)
	world_data.players[player_data.guid] = player_data
	
	WorldData.write(world_data, world_data.guid)
	Ref.main.load_world_from_memory(world_data)

func _on_button_back_pressed():
	Ref.ui.title.current_menu = Ref.ui.title.main
