# player.gd
# Player
extends System

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal move(delta: float, direction: Vector3)
signal move_collide(body: KinematicCollision3D)
signal toggle_debug()
signal toggle_inventory()
signal hotbar_prev()
signal hotbar_next()
signal hotbar_select(index: int)
signal action(mode: int)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const interface_prefab = preload("res://assets/scenes/player_interface.tscn")
var interface: PlayerInterface

const overlay_prefab = preload("res://assets/scenes/player_overlay.tscn")
var overlay: PlayerOverlay

var data: PlayerData
var character: PlayerCharacter

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	interface = Utility.make_child(self, interface_prefab.instantiate(), "Interface")
	interface.hide()
	
	overlay = Utility.make_child(self, overlay_prefab.instantiate(), "Overlay")
	overlay.hide()
	
	# loading finished
	World.loading_finished.connect(func():
		#game_ui.set_player_data(player.data)
		hotbar_next.connect(overlay.hotbar_inventory.next)
		hotbar_prev.connect(overlay.hotbar_inventory.prev)
		hotbar_select.connect(overlay.hotbar_inventory.set_item_index)
		toggle_inventory.connect(interface.toggle_inventory)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.connect(interface.toggle_inventory))
	
	# unloading started
	World.unloading_started.connect(func():
		#game_ui.clear_player_data()
		hotbar_next.disconnect(overlay.hotbar_inventory.next)
		hotbar_prev.disconnect(overlay.hotbar_inventory.prev)
		hotbar_select.disconnect(overlay.hotbar_inventory.set_item_index)
		toggle_inventory.disconnect(interface.toggle_inventory)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.disconnect(interface.toggle_inventory))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
