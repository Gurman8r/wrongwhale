# ui_game.gd
class_name UI_Game
extends Control

signal drop_stack(stack: ItemStack)
signal force_close()

const item_drop = preload("res://assets/scenes/item_drop.tscn")

@onready var player_inventory: Inventory = $PlayerInventory
@onready var equip_inventory: Inventory = $EquipInventory
@onready var external_inventory: Inventory = $ExternalInventory
@onready var grabbed_slot: ItemSlot = $GrabbedSlot

var player_data: PlayerData
var grabbed_stack: ItemStack
var external_inventory_owner

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	force_close.connect(toggle_inventory)
	drop_stack.connect(_on_drop_stack)
	gui_input.connect(_on_gui_input)
	visibility_changed.connect(_on_visibility_changed)

func _unhandled_input(_event) -> void:
	if visible \
	and (Input.is_action_just_pressed("ui_cancel") \
	or Input.is_action_just_pressed("inventory")):
		toggle_inventory()
		get_viewport().set_input_as_handled()

func _physics_process(_delta) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)
	if external_inventory_owner \
	and external_inventory_owner.global_position.distance_to(Ref.player.global_position) > 4:
		force_close.emit()
	
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_player_data(value: PlayerData) -> void:
	if player_data == value: return
	player_data = value
	if not player_data.inventory.inventory_interact.is_connected(on_inventory_interact):
		player_data.inventory.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(player_data.inventory)
	equip_inventory.set_inventory_data(player_data.equip)

func clear_player_data() -> void:
	if not player_data: return
	if player_data.inventory.inventory_interact.is_connected(on_inventory_interact):
		player_data.inventory.inventory_interact.disconnect(on_inventory_interact)
	player_inventory.clear_inventory_data(player_data.inventory)
	equip_inventory.clear_inventory_data(player_data.equip)
	player_data = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func toggle() -> void:
	visible = not visible

func toggle_inventory(value = null) -> void:
	toggle()
	if value and visible:
		set_external_inventory_owner(value)
	else:
		clear_external_inventory()

func set_external_inventory_owner(value) -> void:
	external_inventory_owner = value
	var inventory_data = external_inventory_owner.inventory_data
	if not inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	external_inventory.show()

func clear_external_inventory() -> void:
	if not external_inventory_owner: return
	var inventory_data = external_inventory_owner.inventory_data
	if inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
	external_inventory.clear_inventory_data(inventory_data)
	external_inventory.hide()
	external_inventory_owner = null

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_stack, button]:
		[null, MOUSE_BUTTON_LEFT]: grabbed_stack = inventory_data.grab_stack(index)
		[null, MOUSE_BUTTON_RIGHT]: grabbed_stack = inventory_data.grab_split_stack(index)
		[_, MOUSE_BUTTON_LEFT]: grabbed_stack = inventory_data.drop_stack(grabbed_stack, index)
		[_, MOUSE_BUTTON_RIGHT]: grabbed_stack = inventory_data.drop_single(grabbed_stack, index)
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_stack:
		grabbed_slot.show()
		grabbed_slot.set_stack(grabbed_stack)
	else:
		grabbed_slot.hide()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_drop_stack(stack: ItemStack) -> void:
	var drop = item_drop.instantiate()
	drop.stack = stack
	Ref.world.cell.add(drop, Ref.player.get_drop_position())

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and grabbed_stack:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_stack.emit(grabbed_stack)
				grabbed_stack = null
			MOUSE_BUTTON_RIGHT:
				drop_stack.emit(grabbed_stack.create_single_stack())
				if grabbed_stack.quantity < 1:
					grabbed_stack = null
		update_grabbed_slot()

func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Ref.ui.hud.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Ref.ui.hud.show()
		if grabbed_stack:
			drop_stack.emit(grabbed_stack)
			grabbed_stack = null
			update_grabbed_slot()
		get_tree().paused = false

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
