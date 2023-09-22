# main.gd
class_name Main
extends Node

@onready var settings: Settings = $Settings
@onready var world: World = $World
@onready var ui: UI = $UI

func _init() -> void:
	Game.main = self

func _ready() -> void:
	var player: Player = Game.player
	player.toggle_inventory.connect(ui.toggle_item_interface)
	ui.item_interface.set_player_inventory_data(player.data.inventory)
	ui.item_interface.set_equipment_inventory_data(player.data.equipment)
	ui.item_interface.force_close.connect(ui.toggle_item_interface)
	ui.hotbar_inventory.set_inventory_data(player.data.inventory)
