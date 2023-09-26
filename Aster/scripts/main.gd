# main.gd
class_name Main
extends Node

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
	
	player.toggle_inventory.connect(ui.game.toggle_inventory)
	ui.game.force_close.connect(ui.game.toggle_inventory)
	ui.game.set_player_inventory_data(player.data.inventory)
	ui.game.set_equip_inventory_data(player.data.equip)
	ui.hud.hotbar.set_inventory_data(player.data.inventory)
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(ui.game.toggle_inventory)
	
	good2go = true # done with setup

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func quit():
	get_tree().paused = true
	ui.transition.play("fadeout")
	await ui.transition.finished
	get_tree().quit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
