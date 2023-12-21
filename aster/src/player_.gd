# player_.gd
# Player
extends Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

enum { LEFT, RIGHT, FORWARD, BACKWARD }
enum { PRIMARY_BEGIN, PRIMARY, PRIMARY_END, SECONDARY_BEGIN, SECONDARY, SECONDARY_END, }

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal action(mode: int)
signal moved(delta: float, direction: Vector3)
signal collided(body: KinematicCollision3D)

signal toggle_inventory()
#signal toggle_map()
#signal toggle_collection()
#signal toggle_skills()
#signal toggle_journal()
#signal toggle_settings()
#signal toggle_system()

signal hotbar_prev()
signal hotbar_next()
signal hotbar_select(index: int)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

var canvas_layer: CanvasLayer
var hud: PlayerOverlay
var gui: PlayerInterface

var data: PlayerData
var character: PlayerCharacter

var item_index: int = 0

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer = Util.make(self, CanvasLayer.new(), "CanvasLayer")
	hud = Util.make(canvas_layer, Prefabs.PLAYER_OVERLAY.instantiate(), "Overlay")
	gui = Util.make(canvas_layer, Prefabs.PLAYER_INTERFACE.instantiate(), "Interface")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	assert(canvas_layer.visible)
	hud.hide()
	gui.hide()
	
	# action
	action.connect(func(mode: int):
		assert(data)
		assert(character)
		data.inventory_data.use_stack(item_index, mode, character))
	
	# setup
	World.loading_finished.connect(func():
		assert(data)
		assert(character)
		gui.set_player_data(data)
		hud.set_player_data(data)
		hotbar_next.connect(hud.hotbar_inventory.next)
		hotbar_prev.connect(hud.hotbar_inventory.prev)
		hotbar_select.connect(hud.hotbar_inventory.set_item_index)
		toggle_inventory.connect(gui.toggle_inventory)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.connect(gui.toggle_inventory))
	
	# cleanup
	World.unloading_started.connect(func():
		gui.clear_player_data()
		hud.clear_player_data()
		hotbar_next.disconnect(hud.hotbar_inventory.next)
		hotbar_prev.disconnect(hud.hotbar_inventory.prev)
		hotbar_select.disconnect(hud.hotbar_inventory.set_item_index)
		toggle_inventory.disconnect(gui.toggle_inventory)
		for node in get_tree().get_nodes_in_group("EXTERNAL_INVENTORY"):
			node.toggle_inventory.disconnect(gui.toggle_inventory)
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
	
	if Input.is_action_just_pressed("toggle_inventory"): toggle_inventory.emit()
	if Input.is_action_just_pressed("toggle_map"): gui.set_current_tab(PlayerInterface.MAP)
	if Input.is_action_just_pressed("toggle_collection"): gui.set_current_tab(PlayerInterface.COLLECTION)
	if Input.is_action_just_pressed("toggle_skills"): gui.set_current_tab(PlayerInterface.SKILLS)
	if Input.is_action_just_pressed("toggle_journal"): gui.set_current_tab(PlayerInterface.JOURNAL)
	if Input.is_action_just_pressed("toggle_settings"): gui.set_current_tab(PlayerInterface.SETTINGS)
	if Input.is_action_just_pressed("toggle_system"): gui.set_current_tab(PlayerInterface.SYSTEM)
	
	# hotbar
	if Input.is_action_just_released("hotbar_prev"): hotbar_prev.emit()
	elif Input.is_action_just_released("hotbar_next"): hotbar_next.emit()
	for i in range(0, 10):
		if Input.is_action_just_pressed("hotbar_%d" % [i]):
			hud.hotbar_inventory.set_item_index(i - 1)
			hotbar_select.emit(i - 1)
			break
	item_index = hud.hotbar_inventory.item_index
	
	# movement
	character.move_input[LEFT] = Input.is_action_pressed("move_left")
	character.move_input[RIGHT] = Input.is_action_pressed("move_right")
	character.move_input[FORWARD] = Input.is_action_pressed("move_forward")
	character.move_input[BACKWARD] = Input.is_action_pressed("move_backward")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _physics_process(_delta) -> void:
	if !data or !character: return
	
	if Game.paused: return
	
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
