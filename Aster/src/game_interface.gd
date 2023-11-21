# game_interface.gd
class_name GameInterface
extends Control

enum {
	INVENTORY,
	COLLECTION,
	SKILLS,
	JOURNAL,
	OPTIONS,
	SYSTEM
}

signal drop_stack(stack: ItemStack)
signal force_close()

const item_drop = preload("res://assets/scenes/item_drop.tscn")

@onready var grabbed_slot: ItemSlot = $GrabbedSlot

@onready var overlay: Control = $Overlay
@onready var hotbar_inventory: HotbarInventory = $Overlay/HotbarInventory
@onready var interact_label: Label = $Overlay/InteractLabel

@onready var external_inventory_container: Control = $ExternalInventoryContainer
@onready var external_name_label: Label = $ExternalInventoryContainer/VBoxContainer/ExternalNameLabel
@onready var external_inventory: Inventory = $ExternalInventoryContainer/VBoxContainer/ExternalInventory
@onready var player_name_label: Label = $ExternalInventoryContainer/VBoxContainer/PlayerNameLabel
@onready var player_inventory: Inventory = $ExternalInventoryContainer/VBoxContainer/PlayerInventory

@onready var menu_container: Control = $MenuContainer
@onready var menu_tab_bar: TabBar = $MenuContainer/VBoxContainer/MenuTabBar
@onready var menu_tab_container: TabContainer = $MenuContainer/VBoxContainer/MenuTabContainer

@onready var inventory_tab: Control = $MenuContainer/VBoxContainer/MenuTabContainer/Inventory
@onready var main_inventory: Inventory = $MenuContainer/VBoxContainer/MenuTabContainer/Inventory/MarginContainer/HBoxContainer/MainInventory
@onready var equip_inventory: Inventory = $MenuContainer/VBoxContainer/MenuTabContainer/Inventory/MarginContainer/HBoxContainer/EquipInventory

@onready var collection_tab: Control = $MenuContainer/VBoxContainer/MenuTabContainer/Collection

@onready var skills_tab: Control = $MenuContainer/VBoxContainer/MenuTabContainer/Skills

@onready var options_tab: Control = $MenuContainer/VBoxContainer/MenuTabContainer/Options

@onready var system_tab: Control = $MenuContainer/VBoxContainer/MenuTabContainer/System
@onready var save_button: Button = $MenuContainer/VBoxContainer/MenuTabContainer/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/SaveButton
@onready var save_and_quit_to_title_button: Button = $MenuContainer/VBoxContainer/MenuTabContainer/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/SaveAndQuitToTitleButton
@onready var save_and_quit_to_desktop_button: Button = $MenuContainer/VBoxContainer/MenuTabContainer/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/SaveAndQuitToDesktopButton
@onready var quit_to_title_button: Button = $MenuContainer/VBoxContainer/MenuTabContainer/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/QuitToTitleButton
@onready var quit_to_desktop_button: Button = $MenuContainer/VBoxContainer/MenuTabContainer/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/QuitToDesktopButton

var player_data: PlayerData
var grabbed_stack: ItemStack
var external_inventory_owner

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	force_close.connect(toggle_inventory)
	
	drop_stack.connect(func(stack: ItemStack) -> void:
		var drop = item_drop.instantiate()
		drop.stack = stack
		Ref.world.cell.add(drop, Ref.player.get_drop_position()))
	
	gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.is_pressed() and grabbed_stack:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					drop_stack.emit(grabbed_stack)
					grabbed_stack = null
				MOUSE_BUTTON_RIGHT:
					drop_stack.emit(grabbed_stack.create_single_stack())
					if grabbed_stack.quantity < 1:
						grabbed_stack = null
			update_grabbed_slot())
	
	menu_container.hide()
	external_inventory_container.hide()
	menu_tab_bar.tab_changed.connect(func(tab: int): menu_tab_container.current_tab = tab)
	
	save_button.pressed.connect(Ref.world.save_to_file)
	save_and_quit_to_title_button.pressed.connect(Ref.main.save_world_to_file_and_quit_to_title)
	save_and_quit_to_desktop_button.pressed.connect(Ref.main.save_world_to_file_and_quit_to_desktop)
	quit_to_title_button.pressed.connect(Ref.main.quit_to_title)
	quit_to_desktop_button.pressed.connect(Ref.main.quit_to_desktop)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("toggle_inventory") \
	or Input.is_action_just_pressed("ui_cancel"):
		if external_inventory_container.visible or menu_container.visible:
			force_close.emit()
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
	hotbar_inventory.set_inventory_data(player_data.inventory_data)
	player_name_label.text = "%s:" % [player_data.name]

func clear_player_data() -> void:
	if not player_data: return
	player_data.inventory_data.inventory_interact.disconnect(on_inventory_interact)
	player_data.equip_data.inventory_interact.disconnect(on_inventory_interact)
	player_inventory.clear_inventory_data(player_data.inventory_data)
	main_inventory.clear_inventory_data(player_data.inventory_data)
	equip_inventory.clear_inventory_data(player_data.equip_data)
	hotbar_inventory.clear_inventory_data(player_data.inventory_data)
	player_name_label.text = ""
	player_data = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _update_internal() -> void:
	if menu_container.visible \
	or external_inventory_container.visible:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		overlay.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		overlay.show()
		if grabbed_stack:
			drop_stack.emit(grabbed_stack)
			grabbed_stack = null
			update_grabbed_slot()
		get_tree().paused = false

func get_current_tab() -> int:
	return menu_tab_bar.current_tab

func set_current_tab(tab: int) -> void:
	if tab < 0:
		menu_container.hide()
	else:
		menu_tab_bar.current_tab = tab
		menu_container.show()
	_update_internal()

func toggle_inventory(_external_inventory_owner = null) -> void:
	if _external_inventory_owner: set_external_inventory_owner(_external_inventory_owner)
	elif external_inventory_container.visible: clear_external_inventory()
	elif not menu_container.visible: set_current_tab(0)
	else: set_current_tab(-1)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_external_inventory_owner(value) -> void:
	external_inventory_owner = value
	var inventory_data = external_inventory_owner.inventory_data
	if not inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	external_name_label.text = "%s:" % [value.name]
	external_inventory_container.show()
	_update_internal()

func clear_external_inventory() -> void:
	if not external_inventory_owner: return
	var inventory_data = external_inventory_owner.inventory_data
	if inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
	external_inventory.clear_inventory_data(inventory_data)
	external_inventory_container.hide()
	external_name_label.text = ""
	external_inventory_owner = null
	_update_internal()

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
