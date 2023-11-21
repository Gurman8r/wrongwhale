# game_interface.gd
class_name GameInterface
extends Control

signal drop_stack(stack: ItemStack)
signal force_close()

const item_drop = preload("res://assets/scenes/item_drop.tscn")

@onready var grabbed_slot: ItemSlot = $GrabbedSlot


@onready var external_container = $ExternalContainer
@onready var external_name_label: Label = $ExternalContainer/VBoxContainer/ExternalNameLabel
@onready var external_inventory: Inventory = $ExternalContainer/VBoxContainer/ExternalInventory
@onready var player_name_label: Label = $ExternalContainer/VBoxContainer/PlayerNameLabel
@onready var player_inventory: Inventory = $ExternalContainer/VBoxContainer/PlayerInventory
@onready var main_inventory: Inventory = $MenuTabContainer/TabContainer/Inventory/MarginContainer/HBoxContainer/PlayerInventory
@onready var equip_inventory: Inventory = $MenuTabContainer/TabContainer/Inventory/MarginContainer/HBoxContainer/EquipInventory

@onready var menu_tab_container: Control = $MenuTabContainer
@onready var tab_container: TabContainer = $MenuTabContainer/TabContainer
@onready var inventory_tab: TabBar = $MenuTabContainer/TabContainer/Inventory
@onready var collection_tab: TabBar = $MenuTabContainer/TabContainer/Collection
@onready var options_tab: TabBar = $MenuTabContainer/TabContainer/Options
@onready var system_tab: TabBar = $MenuTabContainer/TabContainer/System

var player_data: PlayerData
var grabbed_stack: ItemStack
var external_inventory_owner

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	force_close.connect(toggle_inventory)
	drop_stack.connect(_on_drop_stack)
	gui_input.connect(_on_gui_input)
	external_container.hide()
	menu_tab_container.hide()

func _unhandled_input(_event) -> void:
	if (visible and (external_container.visible or menu_tab_container.visible)) \
	and (Input.is_action_just_pressed("ui_cancel") \
	or Input.is_action_just_pressed("toggle_inventory")):
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
	player_data.inventory_data.inventory_interact.connect(on_inventory_interact)
	player_data.equip_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(player_data.inventory_data)
	main_inventory.set_inventory_data(player_data.inventory_data)
	equip_inventory.set_inventory_data(player_data.equip_data)
	player_name_label.text = "%s:" % [player_data.name]

func clear_player_data() -> void:
	if not player_data: return
	player_data.inventory_data.inventory_interact.disconnect(on_inventory_interact)
	player_data.equip_data.inventory_interact.disconnect(on_inventory_interact)
	player_inventory.clear_inventory_data(player_data.inventory_data)
	main_inventory.clear_inventory_data(player_data.inventory_data)
	equip_inventory.clear_inventory_data(player_data.equip_data)
	player_name_label.text = ""
	player_data = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func toggle_inventory(_external_inventory_owner = null) -> void:
	if _external_inventory_owner: set_external_inventory_owner(_external_inventory_owner)
	elif external_container.visible: clear_external_inventory()
	else: menu_tab_container.visible = not menu_tab_container.visible
	if menu_tab_container.visible or external_container.visible:
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

func set_external_inventory_owner(value) -> void:
	external_inventory_owner = value
	var inventory_data = external_inventory_owner.inventory_data
	if not inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	external_name_label.text = "%s:" % [value.name]
	external_container.show()

func clear_external_inventory() -> void:
	if not external_inventory_owner: return
	var inventory_data = external_inventory_owner.inventory_data
	if inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
	external_inventory.clear_inventory_data(inventory_data)
	external_container.hide()
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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
