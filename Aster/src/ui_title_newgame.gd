# ui_title_newgame.gd
class_name UI_TitleNewGame
extends PanelContainer

@onready var play_button = $MarginContainer/VBoxContainer/PlayButton
@onready var back_button = $MarginContainer/VBoxContainer/BackButton

@onready var world_name_label = $MarginContainer/VBoxContainer/WorldNamePanel/MarginContainer/HBoxContainer/WorldNameLabel
@onready var world_name_edit = $MarginContainer/VBoxContainer/WorldNamePanel/MarginContainer/HBoxContainer/WorldNameEdit
@onready var world_name_edit_button = $MarginContainer/VBoxContainer/WorldNamePanel/MarginContainer/HBoxContainer/WorldNameEditButton

@onready var player_name_label = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameLabel
@onready var player_name_edit = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameEdit
@onready var player_name_edit_button = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameEditButton

var world_name: String
var player_name: String

func _ready():
	_reset()
	visibility_changed.connect(func(): if not visible: _reset())
	play_button.pressed.connect(_on_button_play_pressed)
	back_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.main)
	
	world_name_label.text = world_name
	world_name_edit_button.pressed.connect(func():
		if not world_name_edit.visible:
			world_name_label.hide()
			world_name_edit.text = world_name
			world_name_edit.show()
		else:
			world_name_edit.hide()
			world_name_label.text = world_name
			world_name_label.show()
		world_name_edit_button.release_focus())
	world_name_edit.text_submitted.connect(func(new_text: String):
		world_name = new_text
		world_name_edit.hide()
		world_name_label.text = world_name
		world_name_label.show())
	
	player_name_label.text = player_name
	player_name_edit_button.pressed.connect(func():
		if not player_name_edit.visible:
			player_name_label.hide()
			player_name_edit.text = player_name
			player_name_edit.show()
		else:
			player_name_edit.hide()
			player_name_label.text = player_name
			player_name_label.show()
		player_name_edit_button.release_focus())
	player_name_edit.text_submitted.connect(func(new_text: String):
		player_name = new_text
		player_name_edit.hide()
		player_name_label.text = player_name
		player_name_label.show())

func _reset():
	world_name = "New World"
	player_name = "New Player"

func _on_button_play_pressed():
	var world_data = WorldData.new()
	world_data.guid = world_name.replace(" ", "_")
	world_data.name = world_name
	world_data.index = 0
	
	var player_data = PlayerData.new()
	player_data.guid = player_name.replace(" ", "_")
	player_data.name = player_name
	player_data.index = 0
	player_data.position = Vector3.ZERO
	player_data.direction = Vector3.FORWARD
	player_data.cell_name = "WorldCell0"
	player_data.inventory.stacks.resize(30)
	player_data.equip.stacks.resize(1)
	world_data.players[player_data.guid] = player_data
	
	WorldData.write(world_data, world_data.guid)
	Ref.main.load_world_from_memory(world_data)
