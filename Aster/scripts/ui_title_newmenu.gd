# ui_title_newmenu.gd
class_name UI_TitleNewMenu
extends Control

@export var world_data: WorldData = WorldData.new()

func _on_button_play_pressed():
	world_data.version = 1
	world_data.guid = "Save_New"
	world_data.name = "New Save"
	world_data.player_data = {}
	world_data.player_data["Player_New"] = PlayerData.new()
	world_data.player_data["Player_New"].guid = "Player_New"
	world_data.player_data["Player_New"].name = "New Player"
	world_data.player_data["Player_New"].cell_name = "WorldCell0"
	world_data.player_data["Player_New"].position = Vector3.ZERO
	world_data.player_data["Player_New"].direction = Vector3.FORWARD
	Ref.main.load_world(world_data)

func _on_button_back_pressed():
	Ref.ui.title.current = Ref.ui.title.mainmenu
