# main.gd
class_name Main
extends Node

@onready var settings: Settings = $Settings
@onready var world: World = $World
@onready var ui : UI = $UI
@onready var player: Player = Game.player

var playing: bool = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _init() -> void:
	Game.main = self

func _ready() -> void:
	get_tree().paused = true
	
	# setup interface
	player.toggle_inventory.connect(ui.item.toggle)
	ui.item.toggle_inventory.connect(ui.item.toggle)
	ui.item.set_player_inventory_data(player.data.inventory)
	ui.item.set_equip_inventory_data(player.data.equip)
	ui.item.force_close.connect(ui.item.toggle)
	ui.hud.item_hotbar.set_inventory_data(player.data.inventory)
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(ui.item.toggle)

func _unhandled_input(event) -> void:
	#if Input.is_action_just_pressed("ui_cancel"): get_tree().quit()
	pass

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func play():
	pass

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
