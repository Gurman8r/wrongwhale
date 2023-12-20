# world_creator.gd
class_name WorldCreator
extends PanelContainer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const NAME_MAX := 12
const SEED_MAX := 16
const SEED_CHARS := "0123456789ABCDEFGHIJKLMNOPQRZTUVWXYZabcdefghijklmnopqrstuvwxyz"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@export var default_cell: String = "Overworld"

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var back_button: Control = $MarginContainer/VBoxContainer/BackButton

@onready var farm_name_panel: Control = $MarginContainer/VBoxContainer/FarmNamePanel
@onready var farm_name_edit: LineEdit = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameEdit
@onready var farm_name_label: Control = $MarginContainer/VBoxContainer/FarmNamePanel/MarginContainer/HBoxContainer/FarmNameLabel

@onready var player_name_panel: Control = $MarginContainer/VBoxContainer/PlayerNamePanel
@onready var player_name_edit: LineEdit = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameEdit
@onready var player_name_label: Label = $MarginContainer/VBoxContainer/PlayerNamePanel/MarginContainer/HBoxContainer/PlayerNameLabel

@onready var player_gender_panel: Control = $MarginContainer/VBoxContainer/PlayerGenderPanel
@onready var player_gender_button_0: Button = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton0
@onready var player_gender_button_1: Button = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton1
@onready var player_gender_button_2: Button = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderButton2
@onready var player_gender_label: Label = $MarginContainer/VBoxContainer/PlayerGenderPanel/MarginContainer/HBoxContainer/PlayerGenderLabel

@onready var player_pet_panel: Control = $MarginContainer/VBoxContainer/PlayerPetPanel
@onready var player_cat_button: Button = $MarginContainer/VBoxContainer/PlayerPetPanel/MarginContainer/HBoxContainer/PlayerCatButton
@onready var player_dog_button: Button = $MarginContainer/VBoxContainer/PlayerPetPanel/MarginContainer/HBoxContainer/PlayerDogButton
@onready var player_pet_label: Label = $MarginContainer/VBoxContainer/PlayerPetPanel/MarginContainer/HBoxContainer/PlayerPetLabel

@onready var seed_edit: LineEdit = $MarginContainer/VBoxContainer/SeedPanel/MarginContainer/HBoxContainer/SeedEdit
@onready var seed_randomize_button: Button = $MarginContainer/VBoxContainer/SeedPanel/MarginContainer/HBoxContainer/SeedRandomizeButton

var world_data: WorldData
var farm_data: FarmData
var player_data: PlayerData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var ev: InputEvent = make_input_local(event)
		if !Rect2(player_name_edit.global_position, player_name_edit.size).has_point(ev.position) \
		or !Rect2(farm_name_edit.global_position, farm_name_edit.size).has_point(ev.position) \
		or !Rect2(seed_edit.global_position, seed_edit.size).has_point(ev.position):
			farm_name_edit.release_focus()
			player_name_edit.release_focus()
			seed_edit.release_focus()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	reset()
	
	visibility_changed.connect(func():
		if visible: reset())
	
	back_button.pressed.connect(func():
		Title.interface.menu = Title.interface.home)
	
	play_button.pressed.connect(_on_button_play_pressed)
	
	# farm name
	farm_name_edit.text_changed.connect(func(new_text: String):
		if farm_data.name == new_text: return
		farm_data.name = new_text
		farm_name_label.text = "%s Farm" % [farm_data.name.rpad(NAME_MAX, ".")])
	farm_name_edit.text_submitted.connect(func(_new_text: String):
		farm_name_edit.release_focus())
	
	# player name
	player_name_edit.text_changed.connect(func(new_text: String):
		if player_data.name == new_text: return
		player_data.name = new_text
		player_name_label.text = "Farmer %s" % [player_data.name.rpad(NAME_MAX, ".")])
	player_name_edit.text_submitted.connect(func(_new_text: String):
		player_name_edit.release_focus())
	
	# player gender
	player_gender_button_0.pressed.connect(func():
		player_data.gender = 1
		player_data.pronoun0 = "She"
		player_data.pronoun1 = "Her"
		player_gender_label.text = "%s/%s" % [player_data.pronoun0, player_data.pronoun1]
		player_gender_button_0.release_focus())
	player_gender_button_1.pressed.connect(func():
		player_data.gender = 1
		player_data.pronoun0 = "He"
		player_data.pronoun1 = "Him"
		player_gender_label.text = "%s/%s" % [player_data.pronoun0, player_data.pronoun1]
		player_gender_button_1.release_focus())
	player_gender_button_2.pressed.connect(func():
		player_data.gender = 2
		player_data.pronoun0 = "They"
		player_data.pronoun1 = "Them"
		player_gender_label.text = "%s/%s" % [player_data.pronoun0, player_data.pronoun1]
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
	
	# random seed
	seed_edit.text_changed.connect(func(new_text: String):
		if world_data.random_seed == new_text: return
		world_data.random_seed = new_text)
	seed_edit.text_submitted.connect(func(_new_text: String):
		seed_edit.release_focus())
	seed_randomize_button.pressed.connect(func():
		world_data.random_seed = Util.rands(SEED_MAX, SEED_CHARS)
		seed_edit.text = world_data.random_seed
		seed_randomize_button.release_focus())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func reset():
	world_data = WorldData.new()
	farm_data = world_data.farm_data
	player_data = world_data.manage(PlayerData.new())
	
	farm_name_edit.text = ""
	farm_name_edit.max_length = NAME_MAX
	farm_name_label.text = "............ Farm"
	
	player_name_edit.text = ""
	player_name_edit.max_length = NAME_MAX
	player_name_label.text = "Farmer ............"
	
	player_gender_label.text = "She/Her"
	player_pet_label.text = "Cat"
	
	seed_edit.text = ""
	seed_edit.max_length = SEED_MAX

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_button_play_pressed():
	assert(world_data)
	assert(farm_data)
	assert(player_data)
	if farm_data.name == "" \
	or player_data.name == "":
		return
	
	world_data.guid = farm_data.name.replace(" ", "_")
	world_data.name = farm_data.name
	world_data.index = WorldData.get_path_list().size()
	
	if world_data.random_seed.is_empty():
		world_data.random_seed = Util.rands(SEED_MAX, SEED_CHARS)
	
	player_data.guid = player_data.name.replace(" ", "_")
	player_data.position = Vector3.ZERO
	player_data.direction = Vector3.FORWARD
	player_data.cell_name = "Farm"
	player_data.inventory.resize(30)
	player_data.equip["0"].resize(1)
	
	var tutorial_chest: ChestData = world_data.manage(ChestData.new())
	tutorial_chest.guid = "Tutorial_Chest"
	tutorial_chest.name = "Tutorial Chest"
	tutorial_chest.cell_name = "Farm"
	tutorial_chest.position = Vector3(0, 0, -3)
	tutorial_chest.direction = Vector3.FORWARD
	tutorial_chest.inventory.resize(30)
	#tutorial_chest.inventory.add_item(preload("res://assets/items/potion.tres"), 15)
	tutorial_chest.inventory.add_item(Registry.get_(Registries.ITEM, "potion"), 15)
	
	WorldData.write(world_data, world_data.guid)
	Game.load_from_memory(world_data)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
