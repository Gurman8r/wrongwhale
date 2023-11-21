# world_creator.gd
class_name WorldCreator
extends PanelContainer

@onready var play_button = $MarginContainer/VBoxContainer/PlayButton
@onready var back_button = $MarginContainer/VBoxContainer/BackButton

@onready var farm_name_panel = $MarginContainer/VBoxContainer/FarmNamePanel
@onready var farm_name_label = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameLabel
@onready var farm_name_edit = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameEdit

@onready var player_name_panel = $MarginContainer/VBoxContainer/PlayerNamePanel
@onready var player_name_edit = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameEdit
@onready var player_name_label = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameLabel

@onready var player_gender_panel = $MarginContainer/VBoxContainer/PlayerGenderPanel
@onready var player_gender_button_0 = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton0
@onready var player_gender_button_1 = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton1
@onready var player_gender_button_2 = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton2
@onready var player_pronoun_label = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerPronounLabel

@onready var player_pet_panel = $MarginContainer/VBoxContainer/PlayerPetPanel
@onready var player_cat_button = $MarginContainer/VBoxContainer/PlayerPetPanel/MarginContainer/HBoxContainer/PlayerCatButton
@onready var player_dog_button = $MarginContainer/VBoxContainer/PlayerPetPanel/MarginContainer/HBoxContainer/PlayerDogButton
@onready var player_pet_label = $MarginContainer/VBoxContainer/PlayerPetPanel/MarginContainer/HBoxContainer/PlayerPetLabel

var world_data: WorldData = null
var farm_data: FarmData = null
var player_data: PlayerData = null

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var evLocal = make_input_local(event)
		if !Rect2(player_name_edit.global_position, player_name_edit.size).has_point(evLocal.position) \
		or !Rect2(farm_name_edit.global_position, farm_name_edit.size).has_point(evLocal.position):
			farm_name_edit.release_focus()
			player_name_edit.release_focus()

func _reset():
	world_data = WorldData.new()
	farm_data = world_data.farm_data
	player_data = PlayerData.new()
	farm_name_label.text = "............ Farm"
	farm_name_edit.text = ""
	player_name_label.text = "Farmer ............"
	player_name_edit.text = ""
	player_pronoun_label.text = "She/Her"
	player_pet_label.text = "Cat"

func _ready():
	_reset()
	visibility_changed.connect(func(): if visible: _reset())
	play_button.pressed.connect(_on_button_play_pressed)
	back_button.pressed.connect(func(): Ref.ui.title.current_menu = Ref.ui.title.main)
	
	# farm name
	farm_name_edit.text_changed.connect(func(new_text: String):
		if farm_data.name == new_text: return
		farm_data.name = new_text
		farm_name_label.text = "%s Farm" % [farm_data.name.rpad(12, ".")])
	farm_name_edit.text_submitted.connect(func(_new_text: String):
		farm_name_edit.release_focus())
	
	# player name
	player_name_edit.text_changed.connect(func(new_text: String):
		if player_data.name == new_text: return
		player_data.name = new_text
		player_name_label.text = "Farmer %s" % [player_data.name.rpad(12, ".")])
	player_name_edit.text_submitted.connect(func(_new_text: String):
		player_name_edit.release_focus())
	
	# player gender
	player_gender_button_0.pressed.connect(func():
		player_data.gender = 1
		player_data.pronoun0 = "She"
		player_data.pronoun1 = "Her"
		player_pronoun_label.text = "%s/%s" % [player_data.pronoun0, player_data.pronoun1]
		player_gender_button_0.release_focus())
	player_gender_button_1.pressed.connect(func():
		player_data.gender = 1
		player_data.pronoun0 = "He"
		player_data.pronoun1 = "Him"
		player_pronoun_label.text = "%s/%s" % [player_data.pronoun0, player_data.pronoun1]
		player_gender_button_1.release_focus())
	player_gender_button_2.pressed.connect(func():
		player_data.gender = 2
		player_data.pronoun0 = "They"
		player_data.pronoun1 = "Them"
		player_pronoun_label.text = "%s/%s" % [player_data.pronoun0, player_data.pronoun1]
		player_gender_button_2.release_focus())
	
	# player pet
	player_cat_button.pressed.connect(func():
		player_pet_label.text = "Cat"
		player_data.pet_species = PlayerData.CAT
		player_data.pet_breed = 0
		player_cat_button.release_focus())
	player_dog_button.pressed.connect(func():
		player_pet_label.text = "Dog"
		player_data.pet_species = PlayerData.DOG
		player_data.pet_breed = 0
		player_dog_button.release_focus())

func _on_button_play_pressed():
	assert(world_data)
	assert(farm_data)
	assert(player_data)
	if farm_data.name == "" \
	or player_data.name == "":
		return
	
	world_data.guid = farm_data.name.replace(" ", "_")
	world_data.name = farm_data.name
	world_data.index = WorldData.count()
	
	player_data.guid = player_data.name.replace(" ", "_")
	player_data.index = world_data.object_data.size()
	player_data.position = Vector3.ZERO
	player_data.direction = Vector3.FORWARD
	player_data.cell_name = "WorldCell0"
	player_data.inventory_data.resize(30)
	player_data.inventory_data.stacks[0] = ItemStack.new()
	player_data.inventory_data.stacks[0].item_data = Ref.database.data.items[1]
	player_data.inventory_data.stacks[0].quantity = 1
	player_data.equip_data.resize(1)
	world_data.object_data[player_data.guid] = player_data
	
	WorldData.write(world_data, world_data.guid)
	Ref.main.load_world_from_memory(world_data)
