# world_creator.gd
class_name WorldCreator
extends PanelContainer

@onready var play_button = $MarginContainer/VBoxContainer/PlayButton
@onready var back_button = $MarginContainer/VBoxContainer/BackButton

var farm_name: String
@onready var farm_name_label = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameLabel
@onready var farm_name_edit = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameEdit
@onready var farm_name_edit_button = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameEditButton

var player_name: String
@onready var player_name_label = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameLabel
@onready var player_name_edit = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameEdit
@onready var player_name_edit_button = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameEditButton


func _reset():
	farm_name = ""
	player_name = ""

func _ready():
	_reset()
	visibility_changed.connect(func(): if not visible: _reset())
	play_button.pressed.connect(_on_button_play_pressed)
	back_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.main)
	
	# world name
	#farm_name_label.text = farm_name
	#farm_name_edit_button.pressed.connect(func():
	#	if not farm_name_edit.visible:
	#		farm_name_label.hide()
	#		farm_name_edit.text = "Farm Name"
	#		farm_name_edit.show()
	#	else:
	#		farm_name_edit.hide()
	#		farm_name_label.text = farm_name
	#		farm_name_label.show()
	#	farm_name_edit_button.release_focus())
	farm_name_edit.text_submitted.connect(func(new_text: String):
		if new_text.is_empty() or farm_name == new_text: return
		farm_name = new_text
		farm_name_edit.hide()
		farm_name_label.text = farm_name
		farm_name_label.show())
	
	# player name
	#player_name_label.text = player_name
	#player_name_edit_button.pressed.connect(func():
	#	if not player_name_edit.visible:
	#		player_name_label.hide()
	#		player_name_edit.text = player_name
	#		player_name_edit.show()
	#	else:
	#		player_name_edit.hide()
	#		player_name_label.text = player_name
	#		player_name_label.show()
	#	player_name_edit_button.release_focus())
	player_name_edit.text_submitted.connect(func(new_text: String):
		if new_text.is_empty() or player_name == new_text: return
		player_name = new_text
		player_name_edit.hide()
		player_name_label.text = player_name
		player_name_label.show())

func _on_button_play_pressed():
	var world_data = WorldData.new()
	world_data.guid = farm_name.replace(" ", "_")
	world_data.name = farm_name
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
