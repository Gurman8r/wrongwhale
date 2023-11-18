# game_overlay.gd
class_name GameOverlay
extends Control

@onready var hotbar: Hotbar = $ItemHotbar
@onready var interact_label: Label = $InteractLabel

var player_data: PlayerData

func _ready():
	interact_label.text = ""
	
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_player_data(value: PlayerData) -> void:
	if player_data == value: return
	player_data = value
	hotbar.set_inventory_data(player_data.inventory_data)

func clear_player_data() -> void:
	if not player_data: return
	hotbar.clear_inventory_data(player_data.inventory_data)
	player_data = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
