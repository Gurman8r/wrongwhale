# main.gd
class_name Main
extends Node

enum {
	STATE_TITLE,
	STATE_PLAYING,
}

@export var game_data: GameData
@export var game_saves: Array[GameData] = []

@onready var settings: Settings = $Settings
@onready var world: World = $World
@onready var ui : UI = $UI

@onready var player: Player = Ref.player

var good2go: bool = false
var playing: bool = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.main = self

func _ready() -> void:
	get_tree().paused = true
	
	# setup interface
	ui.game_interface.set_player_inventory_data(player.data.inventory)
	ui.game_interface.set_equip_inventory_data(player.data.equip)
	ui.game_interface.force_close.connect(ui.game_interface.toggle)
	ui.game_overlay.item_hotbar.set_inventory_data(player.data.inventory)
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(ui.game_interface.toggle)
	
	# done with setup
	good2go = true

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func load_game(_config_file: ConfigFile) -> void:
	pass

func save_game(_config_file: ConfigFile) -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
