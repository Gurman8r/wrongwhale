# player_.gd
# Player
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

enum { LEFT, RIGHT, FORWARD, BACKWARD }
enum { PRIMARY_BEGIN, PRIMARY, PRIMARY_END, SECONDARY_BEGIN, SECONDARY, SECONDARY_END, }

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal action(mode: int)
signal move(delta: float, direction: Vector3)
signal collide(body: KinematicCollision3D)

signal toggle_debug()
signal toggle_inventory()
signal hotbar_prev()
signal hotbar_next()
signal hotbar_select(index: int)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas: CanvasLayer
var overlay: PlayerOverlay
var interface: PlayerInterface

var data: PlayerData
var character: PlayerCharacter

var item_index: int

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	canvas = Util.make(self, CanvasLayer.new(), "Canvas")
	overlay = Util.make(canvas, preload("res://assets/scenes/player_overlay.tscn").instantiate(), "Overlay")
	interface = Util.make(canvas, preload("res://assets/scenes/player_interface.tscn").instantiate(), "Interface")

func _ready() -> void:
	assert(canvas.visible)
	overlay.hide()
	interface.hide()
	
	# action
	action.connect(func(mode: int):
		data.inventory_data.use_stack(item_index, mode, character))
	
	# setup
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
	
	# cleanup
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
	
func _input(event) -> void:
	if !data or !character: return
	
	if Game.paused: return
	
	# pivot
	if event is InputEventMouseMotion:
		character.pivot(event.relative)
	
	# primary
	if Input.is_action_just_pressed("primary"): action.emit(PRIMARY_BEGIN)
	elif Input.is_action_pressed("primary"): action.emit(PRIMARY)
	elif Input.is_action_just_released("primary"): action.emit(PRIMARY_END)
	
	# secondary
	if Input.is_action_just_pressed("secondary"): action.emit(SECONDARY_BEGIN)
	elif Input.is_action_pressed("secondary"): action.emit(SECONDARY)
	elif Input.is_action_just_released("secondary"): action.emit(SECONDARY_END)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if !data or !character: return
	
	if Game.paused: return
	
	# toggle ui
	if Input.is_action_just_pressed("toggle_debug"): toggle_debug.emit()
	if Input.is_action_just_pressed("toggle_inventory"): toggle_inventory.emit()
	if Input.is_action_just_pressed("toggle_collection"): interface.set_current_tab(PlayerInterface.COLLECTION)
	if Input.is_action_just_pressed("toggle_skills"): interface.set_current_tab(PlayerInterface.SKILLS)
	if Input.is_action_just_pressed("toggle_journal"): interface.set_current_tab(PlayerInterface.JOURNAL)
	if Input.is_action_just_pressed("toggle_options"): interface.set_current_tab(PlayerInterface.OPTIONS)
	if Input.is_action_just_pressed("toggle_system"): interface.set_current_tab(PlayerInterface.SYSTEM)
	
	# hotbar
	if Input.is_action_just_released("hotbar_prev"): hotbar_prev.emit()
	elif Input.is_action_just_released("hotbar_next"): hotbar_next.emit()
	for i in range(0, 10):
		if Input.is_action_just_pressed("hotbar_%d" % [i]):
			overlay.hotbar_inventory.set_item_index(i - 1)
			hotbar_select.emit(i - 1)
			break
	item_index = overlay.hotbar_inventory.item_index
	
	# movement
	character.move_input[LEFT] = Input.is_action_pressed("move_left")
	character.move_input[RIGHT] = Input.is_action_pressed("move_right")
	character.move_input[FORWARD] = Input.is_action_pressed("move_forward")
	character.move_input[BACKWARD] = Input.is_action_pressed("move_backward")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
