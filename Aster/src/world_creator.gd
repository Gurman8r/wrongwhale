# world_creator.gd
class_name WorldCreator
extends PanelContainer

@onready var play_button = $MarginContainer/VBoxContainer/PlayButton
@onready var back_button = $MarginContainer/VBoxContainer/BackButton

var farm_name: String
@onready var farm_name_panel = $MarginContainer/VBoxContainer/FarmNamePanel
@onready var farm_name_label = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameLabel
@onready var farm_name_edit = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameEdit

var player_name: String
@onready var player_name_panel = $MarginContainer/VBoxContainer/PlayerNamePanel
@onready var player_name_edit = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameEdit
@onready var player_name_label = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameLabel

var player_gender: int
@onready var player_gender_panel = $MarginContainer/VBoxContainer/PlayerGenderPanel
@onready var player_gender_button_0 = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton0
@onready var player_gender_button_1 = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton1
@onready var player_gender_button_2 = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton2
@onready var player_pronoun_label = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerPronounLabel

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var evLocal = make_input_local(event)
		if !Rect2(player_name_edit.global_position, player_name_edit.size).has_point(evLocal.position) \
		or !Rect2(farm_name_edit.global_position, farm_name_edit.size).has_point(evLocal.position):
			farm_name_edit.release_focus()
			player_name_edit.release_focus()

func _reset():
	farm_name = ""
	player_name = ""
	player_gender = 1
	farm_name_label.text = "____________ Farm"
	farm_name_edit.text = ""
	player_name_label.text = "Farmer ____________"
	player_name_edit.text = ""
	player_pronoun_label.text = "She/Her"

func _ready():
	_reset()
	visibility_changed.connect(func(): if visible: _reset())
	play_button.pressed.connect(_on_button_play_pressed)
	back_button.pressed.connect(func(): Ref.ui.title.menu = Ref.ui.title.main)
	
	farm_name_edit.text_changed.connect(func(new_text: String):
		if farm_name == new_text: return
		farm_name = new_text
		farm_name_label.text = "%s Farm" % [farm_name.rpad(12, "_")])
	farm_name_edit.text_submitted.connect(func(_new_text: String):
		farm_name_edit.release_focus())
	
	player_name_edit.text_changed.connect(func(new_text: String):
		if player_name == new_text: return
		player_name = new_text
		player_name_label.text = "Farmer %s" % [player_name.rpad(12, "_")])
	player_name_edit.text_submitted.connect(func(_new_text: String):
		player_name_edit.release_focus())
	
	player_gender_button_0.pressed.connect(func():
		player_gender = 0
		player_pronoun_label.text = "He/Him"
		player_gender_button_0.release_focus())
	player_gender_button_1.pressed.connect(func():
		player_gender = 1
		player_pronoun_label.text = "She/Her"
		player_gender_button_1.release_focus())
	player_gender_button_2.pressed.connect(func():
		player_gender = 2
		player_pronoun_label.text = "They/Them"
		player_gender_button_2.release_focus())

func _on_button_play_pressed():
	if farm_name == "" or player_name == "": return
	
	var world_data = WorldData.new()
	world_data.guid = farm_name.replace(" ", "_")
	world_data.name = farm_name
	world_data.index = WorldData.count()
	
	var player_data = PlayerData.new()
	player_data.guid = player_name.replace(" ", "_")
	player_data.name = player_name
	player_data.index = world_data.players.size()
	player_data.position = Vector3.ZERO
	player_data.direction = Vector3.FORWARD
	player_data.cell_name = "WorldCell0"
	player_data.inventory.stacks.resize(30)
	player_data.equip.stacks.resize(1)
	player_data.gender = player_gender
	world_data.players[player_data.guid] = player_data
	
	WorldData.write(world_data, world_data.guid)
	Ref.main.load_world_from_memory(world_data)
