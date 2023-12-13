# player_controller.gd
# Player
extends SystemController

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal action(mode: int)
signal move(delta: float, direction: Vector3)
signal move_collide(body: KinematicCollision3D)

signal toggle_debug()
signal toggle_inventory()
signal hotbar_prev()
signal hotbar_next()
signal hotbar_select(index: int)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

const overlay_prefab = preload("res://assets/scenes/player_overlay.tscn")
const interface_prefab = preload("res://assets/scenes/player_interface.tscn")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas: CanvasLayer
var overlay: PlayerOverlay
var interface: PlayerInterface

var data: PlayerData
var character: PlayerCharacter

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	super._init()
	canvas = Utility.make_child(self, CanvasLayer.new(), "Canvas")
	overlay = Utility.make_child(canvas, overlay_prefab.instantiate(), "Overlay")
	interface = Utility.make_child(canvas, interface_prefab.instantiate(), "Interface")

func _ready() -> void:
	assert(canvas.visible)
	overlay.hide()
	interface.hide()
	
	# player action
	action.connect(func(mode: int):
		data.inventory_data.use_stack(character.item_index, mode, character))
	
	# player setup
	World.loading_finished.connect(func():
		assert(data)
		assert(character)
		interface.set_player_data(data)
		overlay.set_player_data(data)
		hotbar_next.connect(overlay.hotbar_inventory.next)
		hotbar_prev.connect(overlay.hotbar_inventory.prev)
		hotbar_select.connect(overlay.hotbar_inventory.set_item_index)
		toggle_inventory.connect(interface.toggle_inventory)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.connect(interface.toggle_inventory))
	
	# player cleanup
	World.unloading_started.connect(func():
		interface.clear_player_data()
		overlay.clear_player_data()
		hotbar_next.disconnect(overlay.hotbar_inventory.next)
		hotbar_prev.disconnect(overlay.hotbar_inventory.prev)
		hotbar_select.disconnect(overlay.hotbar_inventory.set_item_index)
		toggle_inventory.disconnect(interface.toggle_inventory)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.disconnect(interface.toggle_inventory)
		character = null
		data = null)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
