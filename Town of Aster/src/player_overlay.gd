# player_overlay.gd
class_name PlayerOverlay
extends Control

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var hotbar_inventory: HotbarInventory = $HotbarInventory
@onready var interact_label: Label = $InteractLabel

var player_data: PlayerData

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_player_data(value: PlayerData) -> void:
	if player_data == value: return
	player_data = value
	hotbar_inventory.set_inventory_data(player_data.inventory_data)

func clear_player_data() -> void:
	if not player_data: return
	hotbar_inventory.clear_inventory_data(player_data.inventory_data)
	player_data = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
